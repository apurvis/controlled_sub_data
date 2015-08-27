class RemoveFirstScheduledDateColumnFromSubstances < ActiveRecord::Migration
  def change
    remove_column :substances, :first_scheduled_date
  end
end
