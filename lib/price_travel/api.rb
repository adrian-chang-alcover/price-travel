module PriceTravel
  class Api
    
    def initialize
      @countries = {}
    end

    def hotels(params)
      if Moremex::Application.config.mode_offline
        #body = File.open('project/match/acapulco_price_travel.txt').readline()
        body = File.open('project/match/cancun_price_travel.txt').readline()
        #body = File.open('project/match/ciudad_mexico_price_travel.txt').readline()
        hotels = PriceTravel::Utils.parse_hotels(JSON.parse(body))
        return PriceTravel::Response.new(hotels)
      end

      if not params['search-going-to'] or params['search-going-to'] == '' or not params['search-check-in-date'] or params['search-check-in-date'] == '' or not params['search-check-out-date'] or params['search-check-out-date'] == ''
        return PriceTravel::Response.new([], ['There is not enough information to verify availability of hotels.'])
      end

      destinations = Destination.like_name(params['search-going-to']).find_all{|d| d.price_travel_id}
      return PriceTravel::Response.new([], ['Destination not found.']) unless destinations

      hotels = []
      destinations.each do |destination|
        puts("Searching hotels in #{destination.price_travel_id} #{destination.name}")
        p = PriceTravel::Utils.prepare_for_hotels(destination.price_travel_id, params)
        begin
          response = PriceTravel::HTTPService.make_request('/services/hotels/availability', p)
        rescue Net::ReadTimeout => e
          return PriceTravel::Response.new([], [e.to_s])
        rescue Errno::ETIMEDOUT => e
          return BestDay::Response.new([], [e.to_s])
        else
          hotels += JSON.parse(response.body)
        end
      end

      hotels = PriceTravel::Utils.parse_hotels(hotels)

      PriceTravel::Response.new(hotels)
    end

    def flights(params)
      if Moremex::Application.config.mode_offline
        body = File.open('project/match/flights_price_travel.txt').readline()
        flights = PriceTravel::Utils.parse_flights(JSON.parse(body))
        return PriceTravel::Response.new(flights)
      end

      if not params['search-flight-type'] or params['search-flight-type'] == '' or not params['search-flying-from'] or params['search-flying-from'] == '' or not params['search-flying-to'] or params['search-flying-to'] == '' or not params['search-departing-date'] or params['search-departing-date'] == '' or (params['search-flight-type'] == 'Roundtrip' and (not params['search-returning-date'] or params['search-returning-date'] == ''))
        return PriceTravel::Response.new([], ['There is not enough information to verify availability of flights.'])
      end

      departure_airport = Airport.like_name(params['search-flying-from']).first
      return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-from']}."]) unless departure_airport

      arrival_airport = Airport.like_name(params['search-flying-to']).first
      return BestDay::Response.new([], ["Airport name or destination not found for #{params['search-flying-to']}."]) unless arrival_airport

      puts("Searching flights from #{departure_airport.iata} to #{arrival_airport.iata}")
      p = PriceTravel::Utils.prepare_for_flights(departure_airport, arrival_airport, params)
      begin
        response = PriceTravel::HTTPService.make_request('/services/flights/itineraries', p)
      rescue Net::ReadTimeout => e
        return PriceTravel::Response.new([], [e.to_s])
      rescue Errno::ETIMEDOUT => e
        return BestDay::Response.new([], [e.to_s])
      else
        flights = JSON.parse(response.body)
      end

      flights = PriceTravel::Utils.parse_flights(flights)

      PriceTravel::Response.new(flights)
    end

  end
end