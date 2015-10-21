class AddCommentToSubstanceClassifications < ActiveRecord::Migration
  def change
    add_column :substance_classifications, :comment, :text
  end
end
