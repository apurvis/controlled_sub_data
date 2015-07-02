class AddBetterIndexToSchedulesSubstances < ActiveRecord::Migration
  def up
    remove_index :substance_schedules, [:substance_id, :schedule_id]
    add_index :substance_schedules, [:substance_id, :schedule_id, :schedule_level], unique: true, name: 'idx_substance_schedule_level'
  end

  def down
    remove_index :substance_schedules, name: 'idx_substance_schedule_level'
    add_index :substance_schedules, [:substance_id, :schedule_id], unique: true
  end
end
