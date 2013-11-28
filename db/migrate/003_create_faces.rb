class CreateFaces < ActiveRecord::Migration
  def self.up
    create_table :faces do |t|
      t.string :editor
      t.string :name
      t.string :file_name
      t.string :origin_file_name
      t.string :hint
      t.integer :rate_up
      t.integer :rate_down
      t.timestamps
    end
  end

  def self.down
    drop_table :faces
  end
end
