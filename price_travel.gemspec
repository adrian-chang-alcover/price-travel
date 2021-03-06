# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'price_travel/version'

Gem::Specification.new do |spec|
  spec.name          = "price_travel"
  spec.version       = PriceTravel::VERSION
  spec.authors       = ["Adrian"]
  spec.email         = ["adrian.chang.alcover@gmail.com\n"]
  spec.summary       = "PriceTravel is a ruby wrapper for Price Travel"
  spec.description   = "PriceTravel is a lightweight, flexible Ruby SDK for Price Travel. It allows read access to the Price Travel API."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
