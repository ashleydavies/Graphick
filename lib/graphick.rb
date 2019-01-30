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
		puts sources
    sources.map(&:acquire_data)

		g = SVG::Graph::Plot.new({
			:width => 640,
			:height => 480,
			:graph_title => 'Test Graph',
			:show_graph_title => true,
			:key => true,
		})

		sources.map(&:acquire_data).each do |data|
      g.add_data({
        :data => data,
        :title => 'Test data'
      })
		end

		File.open('graph.svg', 'w') {|f| f.write(g.burn_svg_only)}

	end

end
