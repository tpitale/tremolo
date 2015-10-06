module Tremolo
  class NoopTracker
    def initialize(host, port, options={})
    end

    def series(series_name)
      Series.new(self, series_name)
    end

    def increment(series_name, tags = {});end
    def decrement(series_name, tags = {});end
    def timing(series_name, value, tags = {});end
    def time(series_name, tags = {}, &block)
      block.call
    end
    def write_point(series_name, data, tags = {});end
    def write_points(series_name, data, tags = {});end
  end
end
