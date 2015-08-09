class AddMoreIsomersToSubstanceSchedules < ActiveRecord::Migration
  def change
    add_column :substance_statutes, :include_positional_isomers, :boolean
    add_column :substance_statutes, :include_salts_of_isomers, :boolean
    add_column :substance_statutes, :include_salts_of_optical_isomers, :boolean
    add_column :substance_statutes, :include_esters, :boolean
    add_column :substance_statutes, :include_ethers, :boolean
    add_column :substance_statutes, :include_compounds, :boolean
    add_column :substance_statutes, :include_materials, :boolean
    add_column :substance_statutes, :include_preparations, :boolean
  end
end
