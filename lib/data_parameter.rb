module Graphick
	class DataParameter
		attr_accessor :parameter_name, :values, :is_series

		def initialize(command, parameter_name, values, is_series)
			@parameter_name = parameter_name
			@values = values
			@is_series = is_series
			@command = command
		end
		
		def bind_value_index(index)
			raise 'Bad index' unless index < @values.length
			@command.bind_param(@parameter_name, @values[value])
		end
	end
end
