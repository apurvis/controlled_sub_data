class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :state, comment: '2 Character State Code or FEDERAL'
      t.date :start_date, comment: 'Date the schedule became The Law'

      t.timestamps null: false
    end
  end
end
