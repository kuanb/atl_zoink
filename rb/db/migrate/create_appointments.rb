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

class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :defendant_full_name
      t.string :room
      t.string :date
      t.string :time
      t.timestamps
    end
  end
end

CreateAppointments.migrate(:up)
