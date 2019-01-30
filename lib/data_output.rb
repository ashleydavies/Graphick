module Graphick
  class DataOutput
    attr_accessor :is_series

    def initialize(selector, is_series)
      @selector = selector
      @is_series = is_series
    end

    def select(input)
      @selector.select(input)
    end

    def cleanup() end

    def to_s
      series = ''
      series = '[SERIES], ' if @is_series
      "DataOutput<#{series}#{@selector}>"
    end
  end
end