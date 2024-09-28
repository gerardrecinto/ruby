require 'csv'

# Read data from a CSV file
input_file = 'input_data.csv'
data = []

CSV.foreach(input_file, headers: true) do |row|
  data << row.to_h
end

# Process the data (e.g., calculate the average of a numeric column)
total = 0
count = 0

data.each do |row|
  total += row['numeric_column'].to_f
  count += 1
end

average = total / count

# Write the processed data to a new CSV file
output_file = 'output_data.csv'

CSV.open(output_file, 'w') do |csv|
  csv << ['average']
  csv << [average]
end

puts "Data processing complete. Average value: #{average}"
