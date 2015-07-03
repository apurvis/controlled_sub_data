class AddFirstScheduledDateToSubstances < ActiveRecord::Migration
  def change
    add_column :substances, :first_scheduled_date, :date, comment: "Parsed from statements like Chlordiazepoxide (2744) Effective 7/2/1975"
  end
end
