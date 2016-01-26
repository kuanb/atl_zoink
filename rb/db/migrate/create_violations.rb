require_relative "../../app/models.rb"

class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.string :guid
      t.string :description
      t.timestamps
    end

    add_index :violations, :guid
  end
end

CreateViolations.migrate(:up)
