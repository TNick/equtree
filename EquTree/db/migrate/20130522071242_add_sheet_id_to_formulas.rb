class AddSheetIdToFormulas < ActiveRecord::Migration
  def change
    add_column :formulas, :sheet_id, :integer
  end
end
