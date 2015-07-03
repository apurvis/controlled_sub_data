class AddDeletedAtToStatutes < ActiveRecord::Migration
  def change
    add_column :statutes, :deleted_at, :datetime
    add_index :statutes, :deleted_at
  end
end
