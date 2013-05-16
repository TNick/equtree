class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :name
      t.string :directory_id

      t.timestamps
    end
    add_index :sheets, [:directory_id, :created_at]
  end
end
