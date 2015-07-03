class CreateSubstanceAlternateNames < ActiveRecord::Migration
  def change
    create_table :substance_alternate_names do |t|
      t.integer :substance_id
      t.string :name
      t.timestamps null: false
    end
  end
end
