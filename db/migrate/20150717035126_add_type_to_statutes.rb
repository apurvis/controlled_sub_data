class AddTypeToStatutes < ActiveRecord::Migration
  def change
    add_column :statutes, :type, :string
    add_column :statutes, :parent_id, :integer, :comment => 'ID of the parent statute if this is an amendment'
  end
end
