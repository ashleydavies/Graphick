require 'pp'

module Graphick
  class DataCommand
    attr_accessor :title
		
		def initialize(command_words)
			@command = command_words.join ' '
			@title = "Title of Graph"
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
			{
					:results => [results.each_pair {|k, v| [k, v] }.flatten],
					:suggested_x_scale => suggest_axis_scale(results.keys.map {|x| x[0] }),
      		:suggested_y_scale => suggest_axis_scale(results.values)
			}
		end

		# Makes a best-effort suggestion for axis scaling
		# Up to the filtering candidate_arrays, this algorithm is heavily based on Austin Clemens' algorithm here:
		# http://austinclemens.com/blog/2016/01/09/an-algorithm-for-creating-a-graphs-axes/
		def suggest_axis_scale(values)
			min = values.min
			max = values.max

      zero = min <= 0 && max >= 0
      range = max - min

			good_steps = [0.1, 0.2, 0.5, 1, 0.15, 0.25, 0.75]
			ticks = 10

			steps = range / (ticks - 1)
      digits = 0
			if steps >= 1
				digits = steps.round.to_s.length
			else
				places=steps.to_s.split( '.')[1]
				first_place=0

				places.length.times do |i|
					(first_place = i) and break if places[i] != '0'
        end
        digits = -first_place
			end

			candidate_steps=[]
			good_steps.each do |step|
				candidate_steps.push step * 10 ** digits
				candidate_steps.push step * 10 ** digits - 1
				candidate_steps.push step * 10 ** digits + 1
			end
			candidate_steps.reject! { |x| x == 0 }.uniq!

			candidate_arrays = []
			candidate_steps.each do |steps|
				step_array = []
        if zero
          min_steps = (min.abs / steps).ceil
          step_array.push -min_steps * steps
        else
          step_array.push (min / steps).floor * steps
        end

        while step_array[-1] < max
            step_array.push(step_array[-1] + steps)
        end

        next if step_array.length >= 11 or step_array.length < 4
        candidate_arrays.push step_array
      end

			# Special case for a small number of fixed-space integers
			if values.all? {|x| x == x.floor} && values.each_cons(2).map { |e| e[1] - e[0] }.uniq.length == 1
        # TODO: Try to select an appropriate candidate_array
			end

      # TODO: Choose a good candidate_arrays - currently this whole thing is pointless
			candidate_arrays[0][1] - candidate_arrays[0][0]
		end

		def to_s
			"Data Command<#{@command}>\n" +
					"Data Selectors:\n  #{@data_selectors.join "\n  "}\n" +
					"Variables:\n  #{@variables.join "\n  "}\n" +
					"Filters:\n  #{@output_filters.join "\n  "}"
		end

	end
end
