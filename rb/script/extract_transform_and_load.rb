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
# Extract, transform, and load .csv data.
#

def ensure_encoding(str, encoding_class)
  #str.try(:encode!, "UTF-8")
  #str.try(:encode, "utf-8", "utf-8", {:invalid => :replace})
  str.try(:force_encoding, encoding_class).try(:encode, "UTF-8")
end

data_urls = DataUrl.where(:upload_date => "2015-03-12".to_date)
#data_urls = DataUrl.unextracted #.where(:upload_date => "2015-03-12".to_date)
process = ExtractionProcess.new(data_urls)
puts process.inspect

data_urls.each do |du|
  response = HTTParty.get(du.url)
  du.update!({:response_code => response.code, :string_encoding => response.body.encoding.to_s})
  puts du.inspect

  next unless du.response_code == 200

  parse_process = ParseProcess.new(du)
  puts parse_process.inspect

  binding.pry

  row_counter = 0
  CSV.parse(response.body, du.csv_parse_options).each do |row|
    violation = Violation.where({
      :guid => ensure_encoding(row[6], du.string_encoding), # "123456789",
      :description => ensure_encoding(row[7], du.string_encoding), # "A FAKE VIOLATION"
    }).first_or_create!

    citation = Citation.where({
      :guid => ensure_encoding(row[5], du.string_encoding), # "123456789",
      :violation_id => violation.id,
      :location => ensure_encoding(row[2], du.string_encoding), # "123 FAKE STREET",
      :payable => ensure_encoding(row[8], du.string_encoding), # 1
    }).first_or_create!

    Appointment.where({
      :citation_id => citation.id,
      :defendant_full_name => ensure_encoding(row[1], du.string_encoding), # "Fake Person",
      :room => ensure_encoding(row[3], du.string_encoding), # "3B",
      :date => ensure_encoding(row[0], du.string_encoding), # "20-JAN-15",
      :time => ensure_encoding(row[4], du.string_encoding), # "03:00:00 PM"
    }).first_or_create!

    row_counter+=1
  end

  du.update!({:extracted => true, :row_count => row_counter})

  parse_process.row_count = row_counter
  parse_process.ended_at = Time.now
  puts parse_process.inspect
end

process.ended_at = Time.now
puts process.inspect
