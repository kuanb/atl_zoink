require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     'localhost',
  username: 'courtbot',
  password: 'c0urtb0t!',
  database: 'courtbot_atl',
  encoding: 'unicode',
  pool: 5
) #todo: read from environment-specific config file and set password environment variable in production (standard rails config)

class DataUrl < ActiveRecord::Base
  def self.extracted
    where(:extracted => true)
  end

  def self.unextracted
    all - extracted
  end

  def url_date
    upload_date.strftime("%d%m%Y") # "20012014"
  end

  def url
    "http://courtview.atlantaga.gov/courtcalendars/court_online_calendar/codeamerica.#{url_date}.csv"
  end

  def csv_parse_options
    {
      :col_sep => "|", # should parse pipe-delimited data
      :quote_char => "\x00", # should parse unexpected values like "SMITH, DANT"E",
      :encoding => string_encoding # should be able to read "ASCII-8BIT" characters like "\xA0"
    }
  end
end

class Appointment < ActiveRecord::Base
  #belongs_to :citation, :reverse_of => :appointments
end

class Citation < ActiveRecord::Base
  #belongs_to :violation, :reverse_of => :citations
  #has_many :appointments, :reverse_of => :citation
end

class Violation < ActiveRecord::Base
  #has_many :citations, :reverse_of => :violation
end

































#
# Processes
#

class ObservedProcess
  attr_accessor :ended_at

  def duration_seconds
    (@ended_at - @started_at) unless @ended_at.nil?
  end

  def duration_minutes
    duration_seconds / 60 unless duration_seconds.nil?
  end
end

class ExtractionProcess < ObservedProcess
  def initialize(data_urls)
    @url_count = data_urls.count
    @started_at = Time.now
    @ended_at = nil
  end

  def urls_per_minute
    @url_count / duration_minutes
  end

  def inspect
    case @ended_at
    when nil
      "EXTRACTING #{@url_count} of #{DataUrl.count} possible urls ..."
    else
      "EXTRACTED #{@url_count} urls in #{duration_minutes} minutes (#{urls_per_minute} urlpm)."
    end #todo: avoid reaching into DataUrl
  end
end

class ParseProcess < ObservedProcess
  attr_accessor :row_count

  def initialize(data_url)
    @data_url = data_url
    @started_at = Time.now
    @ended_at = nil
  end

  def rows_per_second
    @row_count / duration_seconds
  end

  def inspect
    if !@ended_at.nil? && !@row_count.nil?
      "Parsed #{@row_count} rows in #{duration_seconds} seconds (#{rows_per_second} rps)."
    else
      "Parsing #{@data_url.url} ..."
    end
  end
end
