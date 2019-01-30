module Graphick
  class DataFilterSelector

    def initialize(selector, subfilter)
      @selector = selector
      @subfilter = subfilter
    end

    def filter(input)
      @subfilter.filter(@selector.select(input))
    end

    def to_s
      "FilterSelecting<#{@selector}, #{@subfilter}>"
    end

  end
end