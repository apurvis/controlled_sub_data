class CreateStatuteAmendments < ActiveRecord::Migration
  def change
    create_table :statute_amendments do |t|
      t.integer :statute_id
      t.date :start_date
      t.date :expiration_date
      t.string :source_of_amendment

      t.timestamps null: false
    end
  end
end
