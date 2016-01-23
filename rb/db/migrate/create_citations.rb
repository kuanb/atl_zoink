require_relative "../../app/models.rb"

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
