class AddSubstanceStatuteIdToAlternateNames < ActiveRecord::Migration
  def change
    add_column :substance_alternate_names, :substance_statute_id, :integer, after: :substance_id
  end
end
