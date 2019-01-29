module Graphick
	class DataEnvVar
		attr_accessor :is_series

		def initialize(parameter_name, values, is_series)
			@parameter_name = parameter_name
			@values = values
			@is_series = is_series
			@initial_value = ENV[@parameter_name]
		end
		
		# TODO: Call this - cleanup is important to avoid polluting future graphs
		def cleanup()
			ENV[@parameter_name] = @initial_value
		end

		def bind_value_index(index)
			raise 'Bad index' unless index < @values.length
			ENV[@parameter_name] = @values[index]
		end
	end
end
