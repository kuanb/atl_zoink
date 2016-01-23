require_relative "../../app/models.rb"

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
