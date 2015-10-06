module Tremolo
  class Tracker
    include Celluloid

    trap_exit :sender_died

    attr_reader :namespace

    def initialize(host, port, options={})
      @host, @port = host, port

      @namespace = options[:namespace]
    end

    def series(series_name)
      Series.new(self, series_name)
    end

    def increment(series_name, tags = {})
      write_point(series_name, {value: 1}, tags)
    end

    def decrement(series_name, tags = {})
      write_point(series_name, {value: -1}, tags)
    end

    def timing(series_name, value, tags = {})
      write_point(series_name, {value: value}, tags)
    end

    def time(series_name, tags = {}, &block)
      start = Time.now
      block.call.tap do |_|
        value = ((Time.now-start)*1000).round
        timing(series_name, value, tags)
      end
    end

    def write_point(series_name, data, tags = {})
      write_points(series_name, [data], tags)
    end

    def write_points(series_name, data, tags = {})
      sender.async.write_points([namespace, series_name].compact.join('.'), data, tags)
    end

    private
    def sender
      @sender ||= Sender.new_link(@host, @port)
    end

    def sender_died(actor, reason=nil)
      @sender = nil
    end
  end
end
