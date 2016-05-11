class AddSaltsOfEstersAndSaltsOfEthers < ActiveRecord::Migration
  def change
    add_column :substance_statutes, :include_salts_of_esters, :boolean, after: :include_esters
    add_column :substance_statutes, :include_salts_of_ethers, :boolean, after: :include_ethers
  end
end
