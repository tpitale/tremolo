module Tremolo
  class DataPoint
    def self.from_hash(series_name, h)
      new(series_name, h.reduce(:merge).keys, h)
    end

    attr_accessor :series_name, :columns

    def initialize(series_name, columns, data)
      self.series_name = series_name
      self.columns = columns.sort

      @data = data
    end

    def points
      @points ||= @data.map {|h| h.values_at(*columns) }
    end

    def as_json
      [{
        name: series_name,
        columns: columns,
        points: points
      }]
    end
  end
end
