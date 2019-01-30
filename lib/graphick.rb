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

		sources.map(&:acquire_data).each.with_index do |data, i|
			g = SVG::Graph::Plot.new({
		    :width => 640,
				:height => 480,
				:graph_title => sources[i].title,
				:show_graph_title => true,
				:key => data[:results].length > 1,
				:scale_x_integers => true,
				:scale_x_divisions => data[:suggested_x_scale],
				:scale_y_divisions => data[:suggested_y_scale],
				:show_x_guidelines => false,
      })

			# TODO: Support series
      g.add_data({
        :data => data[:results][0],
        :title => 'Test data'
      })

			File.open('graph.svg', 'w') {|f| f.write(g.burn_svg_only)}
		end

	end

end
