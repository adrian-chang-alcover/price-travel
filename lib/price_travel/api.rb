module PriceTravel
  class Api
    
    def initialize
      @countries = {}
    end

    def hotels(params)
      begin
        response = PriceTravel::HTTPService.make_request('/services/hotels/availability', params)
      rescue SocketError, Errno::ETIMEDOUT => e
        PriceTravel::Response.new([], e.to_s)
      else
        hotels = JSON.parse(response.body)
        PriceTravel::Response.new(hotels)
      end
    end

    def flights(params)
      begin
        response = PriceTravel::HTTPService.make_request('/services/flights/itineraries', params)
      rescue SocketError, Errno::ETIMEDOUT => e
        PriceTravel::Response.new([], e.to_s)
      else
        flights = JSON.parse(response.body)
        PriceTravel::Response.new(flights)
      end
    end

  end
end