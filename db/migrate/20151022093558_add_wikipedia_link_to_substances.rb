class AddWikipediaLinkToSubstances < ActiveRecord::Migration
  def change
    add_column :substances, :wikipedia_url, :string
  end
end
