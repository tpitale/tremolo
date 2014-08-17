require "tremolo/version"

require "json"
require "celluloid/io"

module Tremolo
  def tracker(host, port, options={})
    if host.nil? || port.nil?
      NoopTracker.new(host, port, options)
    else
      Tracker.new(host, port, options)
    end
  end
  module_function :tracker
end

require 'tremolo/data_point'
require 'tremolo/sender'
require 'tremolo/series'
require 'tremolo/tracker'
require 'tremolo/noop_tracker'
