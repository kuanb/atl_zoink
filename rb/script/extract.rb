require 'active_support/all'
require 'httparty'
require 'pp'
require 'pry'
require 'csv'
require_relative "../app/models.rb"

CSV_HEADERS = ["case_date","case_defendant","citation_location",
  "case_room","case_time","citation_id","citation_violation_id",
  "citation_violation_description","citation_payable"
]

#
# Persist metadata of expected urls.
#

AtlantaDataUrl.possible_upload_dates.each do |d|
  AtlantaDataUrl.where(:upload_date => d).first_or_create!
end

puts "EXTRACTING #{AtlantaDataUrl.unextracted.count} OF #{AtlantaDataUrl.count} POSSIBLE URLS ..."

#
# Extract .csv data.
#

AtlantaDataUrl.unextracted.each do |du|
  response = HTTParty.get(du.url)

  du.update!({:response_code => response.code, :string_encoding => response.body.encoding.to_s})
  puts du.inspect

  ####
  #### Handle encodings other than "UTF-8", most notably "ASCII-8BIT"
  ####
  ###encoded_body = response.body
  ###if du.string_encoding != "UTF-8"
  ###  encoded_body = response.body.encode("utf-8", "utf-8", {:invalid => :replace})
  ###end

  csv_parse_options = {
    :col_sep => "|", # should parse pipe-delimited data
    :quote_char => "\x00", # should parse unexpected values like "SMITH, DANT"E",
    :encoding => du.string_encoding # should be able to read "ASCII-8BIT" characters like "\xA0"
  }

  rows = CSV.parse(response.body, csv_parse_options) # ["07-MAY-14", "FORRESTER, KIM", "17TH & INMAN", "6A", "08:00:00 AM", "4678114", "40-6-72", "FAIL TO STOP AT STOP LINE", "1"]

  CSV.open(du.local_csv_file_path, "w", :write_headers=> true, :headers => CSV_HEADERS) do |csv|
    rows.each do |row|
      begin
        csv << row.map{|cell| cell.encode!("UTF-8")} # transcode
      rescue
      end
    end
  end

  du.update!({:extracted => true})
end
