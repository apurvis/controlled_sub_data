class AddCommentToSubstances < ActiveRecord::Migration
  def change
    add_column :substances, :comment, :string
  end
end
