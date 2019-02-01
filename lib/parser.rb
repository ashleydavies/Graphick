require 'data_command'
require 'data_parameter'
require 'data_envvar'
require 'data_filter_in'
require 'data_filter_not'
require 'data_filter_selector'
require 'data_output'
require 'column_selector'
require 'everything_selector'

module Graphick
  class Parser

    def initialize(source)
      @source = source
      @commands = []
      @state = :start
    end

    def parse()
      @source.lines.each &method(:parse_line)
      @commands
    end

    def parse_line(line)
      rest = line.split ' '
      directive = rest.shift
      return if directive == '%'

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
      when 'command'
        if rest.length == 0
          rest = [data_command.command]
        end
        @commands.push DataCommand.new(rest)
      when 'varying'
        data_command.add_variable(parse_variable(rest))
      when 'filtering'
        data_command.add_filter(parse_filter(rest))
      when 'data'
        data_command.add_data_selector(parse_data_selector(rest))
      when 'title'
        data_command.title = rest.join ' '
      when 'output'
        data_command.output_path = rest.join ' '
      end
    end

    def parse_variable(rest)
      series = parse_series(rest)

      varType = rest.shift
      if varType == 'envvar'
        name = rest.shift
        values = parse_values(rest)
        DataEnvVar.new(name, values, series)
      elsif varType.start_with? '$'
        raise "Parsing failed: binding parameter #{rest[0]} (binding parameters not implemented)"
      else
        raise "Parsing failed: unexpected token #{rest[0]} (expecting 'envvar' or $variable)"
      end
    end

    def parse_filter(rest)
      selector = parse_selector(rest)
      filter = nil

      case rest.shift
      when "in"
        filter = DataFilterIn.new(parse_values(rest))
      when "not"
        filter = DataFilterNot.new(parse_filter(rest))
      else
        raise "Unknown filter type"
      end

      unless selector.nil?
        filter = DataFilterSelector.new(selector, filter)
      end

      filter
    end

    def parse_data_selector(rest)
      series = parse_series rest
      case rest.shift
      when "output"
        return DataOutput.new(parse_selector(rest), series)
      else
        raise "Unknown data source #{rest[0]}"
      end
    end

    def parse_selector(rest)
      if rest.length == 0
        return EverythingSelector.new
      end

      case rest[0]
      when "column"
        rest.shift
        column_num = rest.shift.to_i
        raise "Unknown column definition #{rest[0]}" unless rest[0] == "separator"
        rest.shift
        sep = rest.shift
        return ColumnSelector.new(column_num, sep)
      else
        return nil
      end
    end

    def parse_values(collection)
      case collection.shift
      when "sequence"
        startVal = collection.shift
        to = collection.shift
        unless to == "to"
          raise "Parsing failed: expected 'to' in sequence definition (found '#{to}')"
        end
        endVal = collection.shift

        # TODO: Allow floats?
        return (startVal.to_i..endVal.to_i).to_a
      when "vals"
        return collection
      else
        raise 'Parsing failed: unexpected token when parsing values'
      end
    end

    def parse_series(rest)
      if rest[0] == 'series'
        rest.shift
        return true
      end
      false
    end
  end
end

