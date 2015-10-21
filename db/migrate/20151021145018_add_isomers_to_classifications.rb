class AddIsomersToClassifications < ActiveRecord::Migration
  def up
    add_column :substance_statutes, :substance_classification_id, :integer

    Substance.where.not(substance_classification_id: nil).each do |s|
      next if s.statutes.empty?

      s.substance_statutes.each do |ss|
        ss.substance_classification_id = s.substance_classification_id
        ss.save
      end
    end

    remove_column :substances, :substance_classification_id

    add_column :substance_classifications, :include_salts, :boolean
    add_column :substance_classifications, :include_derivatives, :boolean
    add_column :substance_classifications, :include_mixtures, :boolean
    add_column :substance_classifications, :include_isomers, :boolean
    add_column :substance_classifications, :include_optical_isomers, :boolean
    add_column :substance_classifications, :include_geometric_isomers, :boolean
    add_column :substance_classifications, :include_positional_isomers, :boolean
    add_column :substance_classifications, :include_salts_of_isomers, :boolean
    add_column :substance_classifications, :include_salts_of_optical_isomers, :boolean
    add_column :substance_classifications, :include_esters, :boolean
    add_column :substance_classifications, :include_ethers, :boolean
    add_column :substance_classifications, :include_compounds, :boolean
    add_column :substance_classifications, :include_materials, :boolean
    add_column :substance_classifications, :include_preparations, :boolean
  end

  def down
    remove_column :substance_statutes, :substance_classification_id, :integer

    add_column :substances, :substance_classification_id

    remove_column :substance_classifications, :include_salts, :boolean
    remove_column :substance_classifications, :include_derivatives, :boolean
    remove_column :substance_classifications, :include_mixtures, :boolean
    remove_column :substance_classifications, :include_isomers, :boolean
    remove_column :substance_classifications, :include_optical_isomers, :boolean
    remove_column :substance_classifications, :include_geometric_isomers, :boolean
    remove_column :substance_classifications, :include_positional_isomers, :boolean
    remove_column :substance_classifications, :include_salts_of_isomers, :boolean
    remove_column :substance_classifications, :include_salts_of_optical_isomers, :boolean
    remove_column :substance_classifications, :include_esters, :boolean
    remove_column :substance_classifications, :include_ethers, :boolean
    remove_column :substance_classifications, :include_compounds, :boolean
    remove_column :substance_classifications, :include_materials, :boolean
    remove_column :substance_classifications, :include_preparations, :boolean
  end
end

