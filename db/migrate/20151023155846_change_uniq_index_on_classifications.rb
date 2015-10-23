class ChangeUniqIndexOnClassifications < ActiveRecord::Migration
  def change
    remove_index :substance_classifications, :name
    remove_index :substance_classifications, :deleted_at

    add_index :substance_classifications, [:deleted_at, :name, :schedule_level], unique: true, name: 'idx_deleted_name_level'
  end
end
