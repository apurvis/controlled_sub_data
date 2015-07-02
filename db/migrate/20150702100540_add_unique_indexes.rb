class AddUniqueIndexes < ActiveRecord::Migration
  def change
    add_index :substances, :name, unique: true
    add_index :substances, :chemical_formula_smiles_format, unique: true

    add_index :schedules, [:state, :start_date], unique: true

    add_index :substance_schedules, [:substance_id, :schedule_id], unique: true
  end
end
