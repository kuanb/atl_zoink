require 'csv'
require 'pry'
require_relative "../app/models.rb"

def data_dir
  File.join(File.expand_path(".."), "data")
end

file_names = Dir.entries(data_dir)
file_names.select!{|file_name| file_name.include?(".csv")} #file_names.reject!{|file_name| [".","..",".gitignore"].include?(file_name)}
file_names.each do |file_name|
  file_path = File.join(data_dir, file_name)
  row_count = `wc -l #{file_path}`.to_i
  puts "#{file_path} -- #{row_count}"

  CSV.foreach(file_path).each_with_index do |row, i|
    next if i == 0 # skip header row

    violation = Violation.where({
      :guid => row[6], # "123456789",
      :description => row[7], # "A FAKE VIOLATION"
    }).first_or_create!

    citation = Citation.where({
      :guid => row[5], # "123456789",
      :violation_id => violation.id,
      :location => row[2], # "123 FAKE STREET",
      :payable => row[8], # 1
    }).first_or_create!

    Appointment.where({
      :citation_id => citation.id,
      :defendant_full_name => row[1], # "Fake Person",
      :room => row[3], # "3B",
      :date => row[0], # "20-JAN-15",
      :time => row[4], # "03:00:00 PM"
    }).first_or_create!

  end
end
