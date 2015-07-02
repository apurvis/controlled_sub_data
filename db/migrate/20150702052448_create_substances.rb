class CreateSubstances < ActiveRecord::Migration
  def change
    create_table :substances do |t|
      t.string :name
      t.string :classification
      t.string :chemical_formula

      t.timestamps null: false
    end
  end
end
