class RemoveUniqIndexFromSubstances < ActiveRecord::Migration
  def change
    remove_index :substances, :name
    add_index :substances, :name
  end
end
