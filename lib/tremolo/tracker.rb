module Tremolo
  class Tracker
    def initialize(host, port, options={})
      @sender = Sender.new(host, port)
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
      @sender.write_points(series_name, data)
    end
  end
end
