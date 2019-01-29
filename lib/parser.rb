require 'data_command'
require 'data_parameter'

module Graphick
	class Parser
		
		def initialize(source)
			@source = source
			@commands = []
			@state = :start
		end

		def parse()
			@source.lines.each &method(:parse_line)
		end

		def parse_line(line)
			directive, *rest = line.split ' '

			if @state == :start
				unless directive == 'command'
					raise 'Parsing failed: Expecting command'
				end

				@state = :command
				@commands.push DataCommand.new(rest)
				return
			end

			data_command = @commands.last

			case directive
			when 'varying'
				puts "Processing varying"
				series = false
				if rest[0] == 'series'
					series = true
					rest.shift
				end

				if rest[0] == 'envvar'
					
				elsif rest[0].start_with? '$'
					puts "Binding parameter #{rest[0]}"
				else
					raise "Parsing failed: unexpected token #{rest[0]} (expecting 'envvar' or $variable)"
				end
			when 'data'
				puts "Processing data"
			end
		end

	end
end

