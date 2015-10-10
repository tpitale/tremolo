module Tremolo
  class DataPoint
    attr_accessor :series_name, :tags, :values, :time

    def initialize(series_name, data, time=nil)
      self.series_name = series_name
      self.time = time.nil? ? nil : time.to_i

      self.tags = data.fetch(:tags, {})
      self.values = data.fetch(:values, [])
    end

    # key/value pairs of tag data
    def tag_values
      tags.map(&value_mapper).join(',')
    end

    # join the series name and tag values
    def measurement_and_tags
      [series_name, tag_values].delete_if {|v| v.to_s.length == 0}.join(',')
    end

    # join lines for each value
    def lines
      values.map(&line_format).join("\n")
    end

    private
    def fields
      values.map {|point| point.map(&value_mapper)}.join(',')
    end

    def cast(value)
      value
    end

    def line_format
      @line ||= lambda do |values|
        [
          measurement_and_tags,
          fields,
          time
        ].compact.join(' ')
      end
    end

    def value_mapper
      lambda { |(k,v)| "#{k}=#{cast(v)}" }
    end
  end
end
