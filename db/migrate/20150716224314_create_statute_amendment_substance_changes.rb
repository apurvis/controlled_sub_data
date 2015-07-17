class CreateStatuteAmendmentSubstanceChanges < ActiveRecord::Migration
  def change
    create_table :statute_amendment_substance_changes do |t|
      t.integer :statute_amendment_id
      t.integer :substance_id
      t.boolean :is_subtraction
      t.integer :schedule_level, comment: '1, 2, 3, 4, or 5'

      t.timestamps null: false
    end
  end
end
