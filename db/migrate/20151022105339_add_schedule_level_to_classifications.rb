class AddScheduleLevelToClassifications < ActiveRecord::Migration
  def change
    add_column :substance_classifications, :schedule_level, :integer
  end
end
