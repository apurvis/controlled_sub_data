class AddTypeToSubstanceClassifications < ActiveRecord::Migration
  def change
    add_column :substance_classifications, :type, :string
  end
end
