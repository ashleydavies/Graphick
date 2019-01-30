class ColumnSelector

  def initialize(column, separator)
    @column = column
    @separator = separator
  end

  def select(input)
    input.split(@separator)[@column - 1].strip
  end

  def to_s
    "ColumnSelector<#{@column} by '#{@separator}'>"
  end

end