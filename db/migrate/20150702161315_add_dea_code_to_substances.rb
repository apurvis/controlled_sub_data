class AddDeaCodeToSubstances < ActiveRecord::Migration
  def change
    add_column :substances, :dea_code, :integer, comment: "Administrative Controlled Substances Code Number. See https://en.wikipedia.org/wiki/Administrative_Controlled_Substances_Code_Number"
  end
end
