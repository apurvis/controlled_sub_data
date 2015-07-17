class AddIsomersEtcToSubstanceSchedules < ActiveRecord::Migration
  def change
    add_column :substance_statutes, :include_salts, :boolean
    add_column :substance_statutes, :include_derivatives, :boolean
    add_column :substance_statutes, :include_mixtures, :boolean
    add_column :substance_statutes, :include_isomers, :boolean
    add_column :substance_statutes, :include_optical_isomers, :boolean
    add_column :substance_statutes, :include_geometric_isomers, :boolean
  end
end
