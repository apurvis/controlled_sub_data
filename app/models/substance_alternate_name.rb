class SubstanceAlternateName < ActiveRecord::Base
  audited

  belongs_to :substance
  belongs_to :substance_statute

  validates :name, presence: true
end
