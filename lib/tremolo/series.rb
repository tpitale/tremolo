module Tremolo
  class Series
    include Celluloid

    attr_reader :tracker, :series_name

    def initialize(tracker, series_name)
      @tracker, @series_name = tracker, series_name
    end

    def increment(tags = {})
      write_point({value: 1}, tags)
    end

    def decrement(tags = {})
      write_point({value: -1}, tags)
    end

    def timing(value, tags = {})
      write_point({value: value}, tags)
    end

    def time(tags = {}, &block)
      tracker.time(series_name, tags, &block)
    end

    def write_point(data, tags = {})
      write_points([data], tags)
    end

    def write_points(data, tags = {})
      tracker.write_points(series_name, data, tags)
    end
  end
end
