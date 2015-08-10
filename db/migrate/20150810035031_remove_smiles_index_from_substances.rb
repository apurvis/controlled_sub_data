class RemoveSmilesIndexFromSubstances < ActiveRecord::Migration
  def change
    remove_index :substances, :chemical_formula_smiles_format
  end
end
