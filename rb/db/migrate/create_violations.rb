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

class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations, :id => false do |t|
      t.string :guid, :null => false
      t.string :description
      t.timestamps
    end

    add_index :violations, :guid, :unique => true
  end
end

CreateViolations.migrate(:up)
