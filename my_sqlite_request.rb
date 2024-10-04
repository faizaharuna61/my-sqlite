
require 'csv'

class SQLiteRequest
  def initialize
    @queryType = :none
    @TaBleName = nil
    @filters = []
    @columns = []
    @order = nil
    @joinInfo = nil
    @insertData = nil
  end

  def from(TaBleName)
    @TaBleName = TaBleName
    self
  end

  def select(columns)
    @queryType = :select
    @columns += Array(columns).map(&:to_s)
    self
  end

  def where(column, value)
    @filters << [column, value]
    self
  end

  def join(column_a, table_b, column_b)
    raise "Join can only be used with select query" unless @queryType == :select

    @joinInfo = { TaBleName: table_b, col_a: column_a, col_b: column_b }
    self
  end

  def order(direction, column)
    raise "Order can only be used with select query" unless @queryType == :select

    @order = { direction: direction, column: column }
    self
  end

  def insert(TaBleName)
    @queryType = :insert
    @TaBleName = TaBleName
    self
  end

  def values(data)
    raise "Values can only be used with insert or update query" unless [:insert, :update].include?(@queryType)

    @insertData = data
    self
  end

  def set(data)
    values(data)
  end

  def update(TaBleName)
    @queryType = :update
    @TaBleName = TaBleName
    self
  end

  def delete
    @queryType = :delete
    self
  end

  def run
    validate_query
    case @queryType
    when :select then execute_select
    when :insert then execute_insert
    when :update then execute_update
    when :delete then execute_delete
    else raise "Unknown query type"
    end
  rescue StandardError => e
    e.message
  end

  private

  def execute_insert
    data = CSV.read(@TaBleName, headers: true)
    data << @insertData
    update_csv(data)
    puts "Data inserted successfully."
  end

  def execute_update
    data = CSV.read(@TaBleName, headers: true)
    rows_updated = 0
    data.each do |row|
      if matches_conditions?(row)
        @insertData.each { |col, val| row[col] = val }
        rows_updated += 1
      end
    end
    update_csv(data)
    if rows_updated.zero?
      puts "No data matching the update criteria found."
    else
      puts "Data updated successfully."
    end
  end

  def execute_select
    result = []
    data = CSV.read(@TaBleName, headers: true)
    join_data = @joinInfo ? CSV.read(@joinInfo[:TaBleName], headers: true) : nil

    data.each do |row|
      if matches_conditions?(row)
        if join_data && row[@joinInfo[:col_a]]
          match = join_data.find { |j_row| j_row[@joinInfo[:col_b]] == row[@joinInfo[:col_a]] }
          row = row.to_h.merge(match.to_h) if match
        end
        result << (select_all_columns? ? row.to_h : row.to_h.slice(*@columns))
      end
    end

    if @order
      result.sort_by! { |row| row[@order[:column]] }
      result.reverse! if @order[:direction] == :desc
    end

    display_result(result)
  end

  def select_all_columns?
    @columns.include?('*')
  end

  def execute_delete
    data = CSV.read(@TaBleName, headers: true)
    rows_before_deletion = data.size
    data.delete_if { |row| matches_conditions?(row) }
    rows_after_deletion = data.size
    update_csv(data)
    if rows_after_deletion < rows_before_deletion
      puts "Data deleted successfully."
    else
      puts "No data matching the deletion criteria found."
    end
  end

  def matches_conditions?(row)
    @filters.all? { |col, val| row[col] == val }
  end

  def display_result(result)
    result.each { |row| puts row.values.join('|') }
  end

  def validate_query
    raise "No query type specified" if @queryType == :none
    raise "Table name is required" unless @TaBleName
    raise "Table #{@TaBleName} not found" unless File.exist?(@TaBleName)
    
    if @queryType == :select
      if @order && !@columns.include?('*') && !@columns.include?(@order[:column])
        raise "Order column must be selected"
      end
      if @joinInfo && !File.exist?(@joinInfo[:TaBleName])
        raise "Join table #{@joinInfo[:TaBleName]} not found"
      end
    end

    if [:insert, :update].include?(@queryType)
      raise "No data provided for #{@queryType}" unless @insertData
    end
  end

  def update_csv(data)
    CSV.open(@TaBleName, 'w', write_headers: true, headers: data.headers) do |csv|
      data.each { |row| csv << row }
    end
  end
end

def main
  # TEST CASE FOR REQUEST FILE...
#   request = SQLiteRequest.new
#   request = request.from('nba_player_data.csv')
#   request = request.select('name')
#   request.run
end

main