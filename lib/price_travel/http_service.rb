require 'net/http'

module PriceTravel
  module HTTPService

    class << self

      def make_request(uri, params={})
        uri = URI(PriceTravel.server + uri)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port, PriceTravel.proxy_address, PriceTravel.proxy_port,
                             PriceTravel.proxy_username, PriceTravel.proxy_password)
        http.use_ssl = uri.scheme == 'https'
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        request.content_type = 'text/json'
        request.basic_auth(PriceTravel.username, PriceTravel.password)
        http.request(request)
      end

    end

  end
end