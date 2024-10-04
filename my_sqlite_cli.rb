require 'readline'
require_relative 'my_sqlite_request'

def process_input(input)
  input.strip!

  case input
  when /^SELECT\s+\*\s+FROM\s+(\S+)\s*;?$/i
    table = $1
    puts "Processing SELECT statement"
    table = table.sub(/;$/, '')
    columns = %w[name year_start year_end position height weight birth_date college]
    request = SQLiteRequest.new.from(table).select(columns)
    results = request.run
    results.each { |result| puts result.values.join('|') }

  when /^INSERT\s+INTO\s+(\S+)\s+VALUES\s*\((.+)\)\s*;?$/i
    table, values = $1, $2
    puts "Processing INSERT statement"
    table = table.sub(/;$/, '')
    values = values.split(',').map(&:strip)
    columns = CSV.read(table, headers: true).headers
    data = columns.zip(values).to_h
    SQLiteRequest.new.insert(table).values(data).run

  when /^UPDATE\s+(\S+)\s+SET\s+(.+)\s+WHERE\s+(\S+)\s*=\s*'([^']+)'\s*;?$/i
    table, set_data, where_col, where_val = $1, $2, $3, $4
    puts "Processing UPDATE statement"
    table = table.sub(/;$/, '')
    set_data = set_data.split(',').map { |s| s.split('=').map(&:strip) }.to_h
    SQLiteRequest.new.update(table).set(set_data).where(where_col, where_val.strip).run

  when /^DELETE\s+FROM\s+(\S+)\s+WHERE\s+(\S+)\s*=\s*'([^']+)'\s*;?$/i
    table, where_col, where_val = $1, $2, $3
    puts "Processing DELETE statement"
    table = table.sub(/;$/, '')
    SQLiteRequest.new.from(table).where(where_col, where_val.strip).delete.run

  when /^quit$/i
    puts 'Bye!'
    exit
  else
    puts "Unknown command: #{input}"
  end
end

puts "MySQLite version 0.1 #{Time.now.strftime('%Y-%m-%d')}"
while input = Readline.readline('my_sqlite_cli> ', true)
  process_input(input)
end