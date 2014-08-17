require 'simplecov'
SimpleCov.start

require 'bundler/setup'

require 'rspec'
require 'mocha/api'
require 'bourne'

require File.expand_path('../../lib/tremolo', __FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
  config.order = 'random'
end
