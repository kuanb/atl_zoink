require 'csv'
require 'pry'
require 'httparty'
require_relative "../app/models.rb"

#
# Persist metadata of expected urls.
#

("2014-01-01".to_date .. Date.today).each do |d|
  DataUrl.where(:upload_date => d).first_or_create!
end

#
# Identify urls which have not yet been extracted.
#

data_urls = DataUrl.unextracted
process = ExtractionProcess.new(data_urls)
puts process.inspect

#
# Extract, transform, and load .csv data.
#

data_urls.each do |du|
  response = HTTParty.get(du.url)
  du.update!({:response_code => response.code, :string_encoding => response.body.encoding.to_s})
  puts du.inspect

  next unless du.response_code == 200

  rows = CSV.parse(response.body, du.csv_parse_options) # ["07-MAY-14", "FORRESTER, KIM", "17TH & INMAN", "6A", "08:00:00 AM", "4678114", "40-6-72", "FAIL TO STOP AT STOP LINE", "1"]
  du.update!({:row_count => rows.count})
  parse_process = ParseProcess.new(du)
  puts parse_process.inspect

  rows.each do |row|
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

  du.update!({:extracted => true})

  parse_process.ended_at = Time.now
  puts parse_process.inspect
end

process.ended_at = Time.now
puts process.inspect