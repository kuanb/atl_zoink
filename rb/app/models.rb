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

class AtlantaDataFile < ActiveRecord::Base
  #belongs_to :atlanta_data_url, :inverse_of => :atlanta_data_file

  DATA_DIR = File.join(File.expand_path(".."), "data")

  def self.local_file_names
    Dir.entries(DATA_DIR).select!{|file_name| file_name.include?(".csv")}
  end

  def self.parsed
    where(:parsed => true)
  end

  def self.unparsed
    all - parsed
  end

  def file_path
    File.join(DATA_DIR, file_name)
  end
end

class AtlantaDataUrl < ActiveRecord::Base
  #has_one :atlanta_data_file, :inverse_of => :atlanta_data_url

  # The range of possible days on which .csv files could be posted to the server.
  def self.possible_upload_dates
    ("2014-01-01".to_date .. Date.today)
  end

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

  def local_file_name
    "#{upload_date.strftime("%Y-%m-%d")}.csv"
  end

  def local_csv_file_path
    File.join(File.expand_path(".."), "data", local_file_name)
  end
end

#
# Processes
#

class ObservedProcess
  attr_accessor :ended_at

  def duration_seconds
    (@ended_at - @started_at) unless @ended_at.nil?
  end
end

class TransformLoadProcess < ObservedProcess
  def initialize(data_files)
    @file_count = data_files.count
    @started_at = Time.now
    @ended_at = nil
  end

  def duration_minutes
    duration_seconds / 60 unless duration_seconds.nil?
  end

  def files_per_minute
    @file_count / duration_minutes
  end

  def inspect
    case @ended_at
    when nil
      "Processing #{@file_count} of #{AtlantaDataFile.local_file_names.count} files ..."
    else
      "Processed #{@file_count} of #{AtlantaDataFile.local_file_names.count} files in #{duration_minutes} minutes (#{files_per_minute} fpm)"
    end #todo: avoid reaching into AtlantaDataFile
  end
end

class FileParseProcess < ObservedProcess
  def initialize(atl_data_file)
    @file = atl_data_file
    @started_at = Time.now
    @ended_at = nil
  end

  def rows_per_second
    @file.row_count / duration_seconds unless @ended_at.nil?
  end

  def inspect
    case @ended_at
    when nil
      "Processing #{@file.row_count} rows ..."
    else
      "Processed #{@file.row_count} rows in #{duration_seconds} seconds (#{rows_per_second} rps)"
    end
  end
end
