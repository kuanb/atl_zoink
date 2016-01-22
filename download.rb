# to run from root directory: `ruby download.rb`

require 'active_support/all'
require 'httparty'
require 'pp'

# @param [String] date_string Needs to be in DDMMYYY format.
def url(date_string)
  "http://courtview.atlantaga.gov/courtcalendars/court_online_calendar/codeamerica.#{date_string}.csv"
end

# Loop through all dates starting on 1/1/2015 to check for existance of data

dates = ("2014-01-01".to_date .. Date.today)
date_strings = dates.map{ |d| d.strftime("%d%m%Y") }
date_strings.each do |ds|
  puts ds
  response = HTTParty.get(url(ds))
  pp response.code
end
