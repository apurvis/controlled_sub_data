class SubstanceAlternateName < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :substance
  belongs_to :substance_statute

  validates :name, presence: true
end
