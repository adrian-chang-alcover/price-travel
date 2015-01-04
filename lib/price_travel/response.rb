module PriceTravel
    class Response

      attr_reader :resources, :error

      # Creates a new Response object, which standardizes the response received from Price Travel.
      def initialize(resources, error='')
        @resources = resources
        @error = error
      end

      def error?
        not @error.empty?
      end

    end
end
