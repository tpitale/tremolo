# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tremolo/version'

Gem::Specification.new do |spec|
  spec.name          = "tremolo"
  spec.version       = Tremolo::VERSION
  spec.authors       = ["Tony Pitale"]
  spec.email         = ["tpitale@gmail.com"]
  spec.summary       = %q{InfluxDB UDP Tracker built on Celluloid::IO}
  spec.description   = %q{InfluxDB UDP Tracker built on Celluloid::IO}
  spec.homepage      = "https://github.com/tpitale/tremolo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "celluloid-io", ">= 0.17.2"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "bourne"
  spec.add_development_dependency "simplecov"
end
