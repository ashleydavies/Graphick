require 'svggraph'

require 'graphick/version'
require 'parser'

module Graphick
  class Error < StandardError;
  end

  def self.from_file(path)
    contents = File.read(path)
    Dir.chdir File.dirname(path)
    return self.generate(contents)
  end

  def self.generate(graphick_str)
    sources = Graphick::Parser.new(graphick_str).parse()

    sources.map(&:acquire_data).each.with_index do |data, i|
      g = SVG::Graph::Plot.new({
                                   :width => 660,
                                   :height => 480,
                                   :graph_title => sources[i].title,
                                   :show_graph_title => true,
                                   :key => data[:results].length > 1,
                                   :scale_x_integers => true,
                                   :scale_x_divisions => data[:suggested_x_scale],
                                   :scale_y_divisions => data[:suggested_y_scale],
                                   :show_x_guidelines => false,
                                   :show_data_values => false,
                               })

      data[:results].each do |results|
        if data[:series]
          g.add_data({
                         :data => results[1],
                         :title => results[0].to_s
                     })
        else
          g.add_data({:data => results})
        end
      end

      File.open('graph.svg', 'w') {|f| f.write(g.burn_svg_only)}
    end

  end

end
