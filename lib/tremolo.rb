require "tremolo/version"

require "json"
require "celluloid"
Celluloid.boot

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
    unless host.nil? || port.nil?
      Celluloid.supervise type: Tracker, as: as.to_sym, args: [host, port, options]
    end

    fetch(as, NoopTracker.new(host, port, options))
  end

  def fetch(as, default = NoopTracker.new(nil, nil))
    Celluloid::Actor[as.to_sym] || default
  end

  module_function :fetch
  module_function :tracker
  module_function :supervised_tracker
end

require 'tremolo/data_point'
require 'tremolo/sender'
require 'tremolo/series'
require 'tremolo/tracker'
require 'tremolo/noop_tracker'
