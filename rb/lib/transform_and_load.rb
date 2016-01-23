# to run from root directory: `ruby transform_and_load.rb`

require 'csv'
require 'pry'
require 'activerecord'

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

class CourtCase << ActiveRecord::Base
end

class CourtCitation << ActiveRecord::Base
end

CourtCitation.all.count

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
