class RemoveUniquenessOfStatuteIndex < ActiveRecord::Migration
  def up
    remove_index :statutes, [:state, :start_date]
    add_index :statutes, [:state, :start_date]
  end

  def down
    remove_index :statutes, [:state, :start_date]
    add_index :statutes, [:state, :start_date], unique: true
  end
end
