require_relative "../../app/models.rb"

class CreateDataUrls < ActiveRecord::Migration
  def change
    create_table :data_urls do |t|
      t.date :upload_date, :unique => true
      t.integer :response_code
      t.string :string_encoding
      t.integer :row_count
      t.boolean :extracted, :default => false
      t.timestamps
    end
  end
end

CreateDataUrls.migrate(:up)
