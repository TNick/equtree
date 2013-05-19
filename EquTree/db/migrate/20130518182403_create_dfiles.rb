class CreateDfiles < ActiveRecord::Migration
  def change
    create_table :dfiles do |t|
      t.string :name
      t.integer :directory_id
	  t.integer :type

      t.timestamps
    end
  end
end
