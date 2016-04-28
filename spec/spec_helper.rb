require 'simplecov'
SimpleCov.start

require 'bundler/setup'

require 'rspec'
require 'mocha/api'
require 'bourne'
require 'celluloid/current'
require 'celluloid/test'

$CELLULOID_DEBUG = false

require File.expand_path('../../lib/tremolo', __FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
  config.order = 'random'

  config.around :celluloid => true do |e|
    Celluloid.boot
    e.run
    Celluloid.shutdown
    Celluloid::Actor.clear_registry
  end
end
