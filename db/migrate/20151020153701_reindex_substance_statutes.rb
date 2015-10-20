class ReindexSubstanceStatutes < ActiveRecord::Migration
  def up
    remove_index :substance_statutes, name: 'idx_substance_schedule_level'
    remove_index :substance_statutes, :deleted_at
    remove_index :substance_statutes, :statute_id

    add_index :substance_statutes, [:deleted_at, :statute_id]
    add_index :substance_statutes, [:deleted_at, :substance_id, :statute_id, :schedule_level], name: 'idx_deleted_substance_schedule_level', unique: true
    add_index :statutes, [:deleted_at, :start_date]
    remove_index "statutes", ["deleted_at"]
    add_index :substance_statutes, [:deleted_at, :is_expiration, :statute_id], name: 'idx_deleted_statute_expiration'
  end

  def down
    remove_index :substance_statutes, name: 'idx_deleted_statute_expiration'
    add_index "statutes", ["deleted_at"], name: "index_statutes_on_deleted_at", using: :btree
    remove_index :statutes, [:deleted_at, :start_date]
    remove_index :substance_statutes, name: 'idx_deleted_substance_schedule_level'
    remove_index :substance_statutes, [:deleted_at, :statute_id]

    add_index "substance_statutes", ["substance_id", "statute_id", "schedule_level"], name: "idx_substance_schedule_level", unique: true, using: :btree
    add_index :substance_statutes, :deleted_at
    add_index :substance_statutes, :statute_id
  end
end
