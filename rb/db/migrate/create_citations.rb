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

class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations do |t|
      t.string :guid
      t.string :violation_id
      t.string :violation_description #todo: deprecate and move into :violations table
      t.string :location
      t.boolean :payable

      t.timestamps
    end

    add_index :citations, :guid
    add_index :citations, :violation_id
  end
end

CreateCitations.migrate(:up)
