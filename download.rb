# to run from root directory: `ruby download.rb`

require 'active_support/all'
require 'httparty'
require 'pp'
require 'pry'

# The range of possible days on which .csv files could be posted to the server.
def days
  ("2014-01-01".to_date .. Date.today)
end

# @param [Date] day
def csv_url(day)
  url_date = day.strftime("%d%m%Y")
  "http://courtview.atlantaga.gov/courtcalendars/court_online_calendar/codeamerica.#{url_date}.csv"
end

# @param [Date] day
def csv_file_path(day)
  file_name = day.strftime("%Y-%m-%d")
  File.join("data", file_name)
end

def csv_headers
  ["case_date","case_defendant","citation_location","case_room","case_time",
    "citation_id","citation_violation_id","citation_violation_description","citation_payable"]
end

days.each do |d|
  response = HTTParty.get(csv_url(d))
  puts "#{d} - #{response.code}"
  next if response.code == 404

  rows = CSV.parse(response.body, {:col_sep => "|"}) # ["07-MAY-14", "FORRESTER, KIM", "17TH & INMAN", "6A", "08:00:00 AM", "4678114", "40-6-72", "FAIL TO STOP AT STOP LINE", "1"]

  CSV.open(csv_file_path(d), "w", :write_headers=> true, :headers => csv_headers) do |csv|
    rows.each do |row|
      begin
        csv << row
      rescue
        binding.pry
      end
    end
  end
end
