class AddCommentsToStatutesAndSubstanceStatutes < ActiveRecord::Migration
  def change
    add_column :statutes, :comment, :text
    add_column :substance_statutes, :comment, :text
  end
end
