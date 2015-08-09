class AddDuplicateFederalAsOfDateToStatutes < ActiveRecord::Migration
  def change
    add_column :statutes, :duplicate_federal_as_of_date, :date
  end
end
