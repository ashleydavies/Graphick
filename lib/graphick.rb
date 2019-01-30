require 'svggraph'

require 'graphick/version'
require 'parser'

module Graphick
  class Error < StandardError; end

	def self.from_file(path)
		return self.generate(File.read(path))
	end

	def self.generate(graphick_str)
		sources = Graphick::Parser.new(graphick_str).parse()

		g = SVG::Graph::Line.new({
			:width => 640,
			:height => 480,
			:graph_title => 'Test Graph',
			:show_graph_title => true,
			:key => true,
			:stacked => true,
			:fields => %w{a b c}
			
		})

		g.add_data({
			:data => [1, 2, 3, 4, 5, 10],
			:title => 'Test data'
		})

		File.open('graph.svg', 'w') {|f| f.write(g.burn_svg_only)}

	end

end
