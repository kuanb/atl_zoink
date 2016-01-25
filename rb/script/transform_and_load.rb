require 'csv'
require 'pry'
require_relative "../app/models.rb"

data_files = AtlantaDataFile.all

process = TransformLoadProcess.new(data_files)
puts process.inspect

data_files.each_with_index do |f, i|
  puts f.inspect

  parse_process = FileParseProcess.new(f)

  CSV.foreach(f.file_path).each_with_index do |row, i|
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

  parse_process.ended_at = Time.now
  puts parse_process.inspect
end

process.ended_at = Time.now
puts process.inspect
