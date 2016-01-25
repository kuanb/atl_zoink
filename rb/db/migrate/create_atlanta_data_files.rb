require_relative "../../app/models.rb"

class CreateAtlantaDataFiles < ActiveRecord::Migration
  def change
    create_table :atlanta_data_files do |t|
      t.string :file_name
      t.boolean :parsed, :default => false
      t.integer :row_count
      t.timestamps
    end

    add_index :atlanta_data_files, :parsed
  end
end

CreateAtlantaDataFiles.migrate(:up)
