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

  def supervised_tracker(as, host, port, options={})
    if host.nil? || port.nil?
      NoopTracker.new(host, port, options)
    else
      Tracker.supervise_as as.to_sym, host, port, options
      Celluloid::Actor[as.to_sym]
    end
  end

  module_function :tracker
  module_function :supervised_tracker
end

require 'tremolo/data_point'
require 'tremolo/sender'
require 'tremolo/series'
require 'tremolo/tracker'
require 'tremolo/noop_tracker'
