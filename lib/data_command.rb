module Graphick 
  class DataCommand
		
		def initialize(command_words)
			@command = command_words
			@bound_params = {}
		end

		def bind_param(param, val)
			@bound_params[param] = val
		end

	end
end
