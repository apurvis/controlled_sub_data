class AddIsExpirationToSubstanceStatutes < ActiveRecord::Migration
  def change
    add_column :substance_statutes, :is_expiration, :boolean
  end
end
