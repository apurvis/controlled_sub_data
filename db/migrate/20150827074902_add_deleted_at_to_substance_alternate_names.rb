class AddDeletedAtToSubstanceAlternateNames < ActiveRecord::Migration
  def change
    add_column :substance_alternate_names, :deleted_at, :datetime
    add_index :substance_alternate_names, :deleted_at
    add_index :substance_alternate_names, :substance_id
    add_index :substance_alternate_names, :substance_statute_id

    add_index :substance_statutes, :statute_id
  end
end
