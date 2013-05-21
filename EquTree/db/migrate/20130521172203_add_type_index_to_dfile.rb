class AddTypeIndexToDfile < ActiveRecord::Migration
  def change
    add_column :dfiles, :type_index, :integer
  end
end
