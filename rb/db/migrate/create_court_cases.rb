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

class CreateCourtCases < ActiveRecord::Migration
  def change
    create_table :court_cases do |t|
      t.string :name
      t.text :description

      t.timestamps, :null => false
    end
  end
end

CreateCourtCases.migrate(:up)
