class RenameSchedulesToStatutes < ActiveRecord::Migration
  def change
    rename_table :schedules, :statutes
    rename_table :substance_schedules, :substance_statutes
    rename_column :substance_statutes, :schedule_id, :statute_id

    add_column :statutes, :blue_book_code, :string
    add_column :statutes, :name, :string
    add_column :statutes, :expiration_date, :date
  end
end
