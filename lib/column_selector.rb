class ColumnSelector

  def initialize(column, separator)
    @column = column
    @separator = separator
  end

  def select(input)
    input.split(@separator)[@column]
  end

  def to_s
    "Column Selector<#{@column} by '#{@separator}'>"
  end

end