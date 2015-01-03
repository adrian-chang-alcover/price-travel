require 'net/http'

module PriceTravel
  module HTTPService

    PRODUCTION_SERVER = 'https://api.pricetravel.com'
    DEVELOPMENT_SERVER = 'http://test-api.pricetravel.com.mx'

    class << self

      def make_request(uri, params={})
        uri = URI(DEVELOPMENT_SERVER + uri)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        request.content_type = 'text/json'
        request.basic_auth(Figaro.env.price_travel_user, Figaro.env.price_travel_password)
        http.request(request)
      end

    end
  end
end