module Tremolo
  class Series
    include Celluloid

    attr_reader :tracker, :series_name

    def initialize(tracker, series_name)
      @tracker, @series_name = tracker, series_name
    end

    def increment
      write_point({value: 1})
    end

    def decrement
      write_point({value: -1})
    end

    def timing(value)
      write_point({value: value})
    end

    def time(&block)
      tracker.time(series_name, &block)
    end

    def write_point(data)
      write_points([data])
    end

    def write_points(data)
      tracker.write_points(series_name, data)
    end
  end
end
