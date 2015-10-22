class AddStatuteIdToSubstanceClassifications < ActiveRecord::Migration
  def change
    add_column :substance_classifications, :statute_id, :integer

    add_index :substance_statutes, [:deleted_at, :substance_classification_id], name: 'idx_deleted_at_classification'
  end
end
