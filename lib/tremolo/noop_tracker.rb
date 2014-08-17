module Tremolo
  class NoopTracker
    def initialize(host, port, options={})
    end

    def series(series_name)
      Series.new(self, series_name)
    end

    def increment(series_name);end
    def decrement(series_name);end
    def timing(series_name, value);end
    def time(series_name, &block)
      block.call
    end
    def write_point(series_name, data);end
    def write_points(series_name, data);end
  end
end
