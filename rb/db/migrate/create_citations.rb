require_relative "../../app/models.rb"

class CreateCitations < ActiveRecord::Migration
  def change
    create_table :citations do |t|
      t.string :guid
      t.integer :violation_id
      t.string :location
      t.boolean :payable

      t.timestamps
    end

    add_index :citations, :guid
    add_index :citations, :violation_id
  end
end

CreateCitations.migrate(:up)
