require_relative "../../app/models.rb"

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
