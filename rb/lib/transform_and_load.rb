require 'csv'
require 'pry'
require 'active_record'
require 'pg'

#
# LIBRARY
#

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
end

class Citation < ActiveRecord::Base
end

class Violation < ActiveRecord::Base
  self.primary_key = :guid
end

=begin
#
# SCRIPT
#

file_names = Dir.entries(File.join("data"))
file_names.select!{|file_name| file_name.include?(".csv")} #file_names.reject!{|file_name| [".","..",".gitignore"].include?(file_name)}
file_names.each do |file_name|
  file_path = File.join(Dir.pwd, "data", file_name)
  pp file_path

  CSV.foreach(file_path) do |row|
    pp row

    court_case_attributes = {

    }
    court_case = CourtCase.create!(court_case_attributes)
    binding.pry
  end
end

=end
