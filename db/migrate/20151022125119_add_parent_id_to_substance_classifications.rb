class AddParentIdToSubstanceClassifications < ActiveRecord::Migration
  def change
    add_column :substance_classifications, :parent_id, :integer
    add_column :statutes, :external_link, :string
  end
end
