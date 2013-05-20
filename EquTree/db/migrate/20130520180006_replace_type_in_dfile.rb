class ReplaceTypeInDfile < ActiveRecord::Migration
  def change
    rename_column :dfiles, :type, :ftype
  end
end
