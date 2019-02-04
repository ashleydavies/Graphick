require 'pp'

module Graphick
  class DataFilterIn

    def initialize(values)
      @values = values
    end

    def filter(input)
      # TODO: Fix this ugly hack due to how values are generated
      if input.match /^-?[0-9]*\.?[0-9]*(e-?[0-9]+)?$/
        (@values.include? input) || (@values.include? input.to_f) || (@values.include? input.to_i)
      else
        @values.include? input
      end
    end

    def to_s
      "FilterIn<'#{@values.join ', '}'>"
    end

  end
end
