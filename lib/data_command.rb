require 'pp'

module Graphick
  class DataCommand
		
		def initialize(command_words)
			@command = command_words.join ' '
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

		def acquire_data
			puts "Generating data"

			# Some basic validation so we know we can actually generate a graph
			data_sources = @variables + @data_selectors
      puts "Data sources: #{data_sources.length} (#{@variables.length} variables, #{@data_selectors.length} data sources)"
			raise 'Bad number of data sources ' unless [2, 3].include? data_sources.length

      series_count = data_sources.map(&:is_series).select(&:itself).length
      raise 'Expected a single `series` data source, since three data sources were given' if data_sources.length == 3 unless series_count == 1

			raise 'Expected no `series` data source, since only one other data source is present' if data_sources.length == 2 unless series_count == 0

			results = {}
			# Cartesian product f value options
			variable_idx_ranges = @variables.map &:num_values
			variable_idx_ranges.reduce(:*).times do |i|
				# Map i to a value for each parameter (selecting from cartesian product)
				indexes = []
				params = []
				acc = i
				variable_idx_ranges.each do |varSize|
				  indexes.push acc % varSize
					acc /= varSize
				end

				# Bind the appropriate variables
				@variables.length.times do |idx|
				  params[idx] = @variables[idx].bind_value_index(indexes[idx])
				end

				results[params] = `#{@command}`.chomp.to_i
			end

			# Now wrangle the results into the correct format for rendering a graph, depending on if a series is defined
			# TODO: Support series
			results.each_pair {|k, v| [k, v] }.flatten
		end

		def to_s
			"Data Command<#{@command}>\n" +
					"Data Selectors:\n  #{@data_selectors.join "\n  "}\n" +
					"Variables:\n  #{@variables.join "\n  "}\n" +
					"Filters:\n  #{@output_filters.join "\n  "}"
		end

	end
end
