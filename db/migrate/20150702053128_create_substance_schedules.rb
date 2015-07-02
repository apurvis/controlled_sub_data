class CreateSubstanceSchedules < ActiveRecord::Migration
  def change
    create_table :substance_schedules do |t|
      t.integer :substance_id
      t.integer :schedule_id
      t.integer :schedule_level, comment: '1, 2, 3, 4, or 5'

      t.timestamps null: false
    end
  end
end
