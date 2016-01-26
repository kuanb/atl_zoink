require_relative "../../app/models.rb"

class CreateAtlantaDataUrls < ActiveRecord::Migration
  def change
    create_table :atlanta_data_urls do |t|
      t.date :upload_date, :unique => true
      t.integer :response_code
      t.string :string_encoding
      t.boolean :extracted, :default => false
      t.timestamps
    end
  end
end

CreateAtlantaDataUrls.migrate(:up)
