class CreateSubstances < ActiveRecord::Migration
  def change
    create_table :substances do |t|
      t.string :name
      t.string :classification, comment: "e.g. opioid, stimulant, depressant"
      t.string :chemical_formula, comment: "In a readable format, e.g. N-ethyl-3-piperidyl benzilat"
      t.string :chemical_formula_smiles_format, comment: "Follows the SMILE standard: https://en.wikipedia.org/wiki/Simplified_molecular-input_line-entry_system"
      t.timestamps null: false
    end
  end
end
