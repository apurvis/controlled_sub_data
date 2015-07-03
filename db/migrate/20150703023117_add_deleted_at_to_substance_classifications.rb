class AddDeletedAtToSubstanceClassifications < ActiveRecord::Migration
  def change
    add_column :substance_classifications, :deleted_at, :datetime
    add_index :substance_classifications, :deleted_at
  end
end
