module Tremolo
  class DataPoint
    attr_accessor :series_name, :data, :time

    def initialize(series_name, data, time=nil)
      self.series_name = series_name
      self.data = data
      self.time = time.nil? ? nil : time.to_i
    end

    def values
      @data.map {|h| h.map {|k,v| "#{k}=#{cast(v)}" }.join(',')}
    end

    def cast(value)
      value
    end

    def line
      @line ||= lambda {|values| [series_name, values, time].compact.join(' ')}
    end

    def lines
      values.map {|v| line.call(v)}.join("\n")
    end
  end
end
