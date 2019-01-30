module Graphick
	class DataFilterIn

		def initialize(values)
			@values = values
		end

		def filter(input)
			@values.contains? input
    end

		def to_s
			"FilterIn<'#{@values.join ', '}'>"
		end
		
	end
end