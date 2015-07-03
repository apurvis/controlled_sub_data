class AddDeletedAtToSubstances < ActiveRecord::Migration
  def change
    add_column :substances, :deleted_at, :datetime
    add_index :substances, :deleted_at
  end
end
