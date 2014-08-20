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

    def increment(series_name)
      write_point(series_name, {value: 1})
    end

    def decrement(series_name)
      write_point(series_name, {value: -1})
    end

    def timing(series_name, value)
      write_point(series_name, {value: value})
    end

    def time(series_name, &block)
      start = Time.now
      block.call.tap do |_|
        value = ((Time.now-start)*1000).round
        timing(series_name, value)
      end
    end

    def write_point(series_name, data)
      write_points(series_name, [data])
    end

    def write_points(series_name, data)
      sender.async.write_points([namespace, series_name].compact.join('.'), data)
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
