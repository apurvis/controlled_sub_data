class SubstanceClassification < ActiveRecord::Base
  acts_as_paranoid
  audited

  has_many :substances
  validates_uniqueness_of :name
end
