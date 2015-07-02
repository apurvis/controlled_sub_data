class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :state, comment: '2 Character State Code or FEDERAL'
      t.integer :year

      t.timestamps null: false
    end
  end
end
