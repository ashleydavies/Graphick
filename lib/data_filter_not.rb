module Graphick
  class DataFilterNot

    def initialize(filter)
      @filter = filter
    end

    def filter(input)
      not @filter.filter(input)
    end

    def to_s
      "FilterNot<#{@filter}>"
    end

  end
end