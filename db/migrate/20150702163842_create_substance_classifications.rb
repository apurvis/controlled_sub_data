class CreateSubstanceClassifications < ActiveRecord::Migration
  def change
    create_table :substance_classifications do |t|
      t.string :name
      t.timestamps null: false
    end

    add_index :substance_classifications, :name, unique: true
    remove_column :substances, :classification, :string
    add_column :substances, :substance_classification_id, :integer
  end
end
