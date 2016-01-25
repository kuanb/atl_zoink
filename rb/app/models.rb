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
) #todo: read from common config

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

class AtlantaDataFile
  DATA_DIR = File.join(File.expand_path(".."), "data")

  def self.file_names
    Dir.entries(DATA_DIR).select!{|file_name| file_name.include?(".csv")}
  end

  def self.all
    file_names.map do |file_name|
      AtlantaDataFile.new(file_name)
    end
  end

  def initialize(file_name)
    @file_name = file_name
  end

  def file_path
    File.join(DATA_DIR, @file_name)
  end

  def row_count
    `wc -l #{file_path}`.to_i
  end

  def inspect
    "#{self.class} -- #{file_path} -- #{row_count} rows"
  end
end

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
      "Processing #{@file_count} files ..."
    else
      "Processed #{@file_count} files in #{duration_minutes} minutes (#{files_per_minute} fpm)"
    end
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
    else
      "Processed #{@file.row_count} rows in #{duration_seconds} seconds (#{rows_per_second} rps)"
    end
  end
end
