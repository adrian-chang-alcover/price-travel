require 'rails/generators'

module PriceTravel
  class InitializeGenerator < Rails::Generators::Base

    source_root File.expand_path("../../templates", __FILE__)

    def copy_initializer_file
      copy_file "price_travel.txt", "config/initializers/price_travel.rb"
    end

  end
end