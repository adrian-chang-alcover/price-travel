require "price_travel/version"

if defined?(Rails)
  require 'generators/price_travel/initialize_generator'
end

module PriceTravel
  class << self
    attr_accessor :username, :password, :server, :locale, :currency_code

    # Default way to setup PriceTravel. Run generator to create
    # a fresh initializer with all configuration values.
    def setup
      yield self
    end

    def root_path
      Gem::Specification.find_by_name("price_travel").gem_dir
    end
  end
end
