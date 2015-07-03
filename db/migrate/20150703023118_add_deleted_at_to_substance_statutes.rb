class AddDeletedAtToSubstanceStatutes < ActiveRecord::Migration
  def change
    add_column :substance_statutes, :deleted_at, :datetime
    add_index :substance_statutes, :deleted_at
  end
end
