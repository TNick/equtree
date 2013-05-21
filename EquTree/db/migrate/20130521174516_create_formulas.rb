class CreateFormulas < ActiveRecord::Migration
  def change
    create_table :formulas do |t|
      t.text :omath
      t.text :descr

      t.timestamps
    end
  end
end
