class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.text :description

      t.timestamps
    end
  end
end
