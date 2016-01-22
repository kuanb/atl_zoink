# to run from root directory: `ruby transform_and_load.rb`

require 'csv'
require 'pry'

file_names = Dir.entries(File.join("data"))
file_names.select!{|file_name| file_name.include?(".csv")} #file_names.reject!{|file_name| [".","..",".gitignore"].include?(file_name)}
file_names.each do |file_name|
  file_path = File.join(Dir.pwd, "data", file_name)
  pp file_path

  CSV.foreach(file_path) do |row|
    pp row
  end
end
