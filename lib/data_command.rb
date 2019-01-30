module Graphick 
  class DataCommand
		
		def initialize(command_words)
			@command = command_words
			@variables = []
			@data_selectors = []
			@output_filters = []
			@bound_params = {}
		end

		def bind_param(param, val)
			@bound_params[param] = val
		end

		def add_variable(var)
			@variables.push var
		end

		def add_filter(filter)
			@output_filters.push filter
		end

		def add_data_selector(data_selector)
			@data_selectors.push data_selector
		end

		def to_s
			"Data Command<#{@command.join ' '}>\n" +
					"Data Selectors:\n  #{@data_selectors.join "\n  "}\n" +
					"Variables:\n  #{@variables.join "\n  "}\n" +
					"Filters:\n  #{@output_filters.join "\n  "}"
		end

	end
end
