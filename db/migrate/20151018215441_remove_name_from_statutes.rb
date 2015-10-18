class RemoveNameFromStatutes < ActiveRecord::Migration
  def change
    remove_column :statutes, :name, :string
  end
end
