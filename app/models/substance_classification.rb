class SubstanceClassification < ActiveRecord::Base
  include IncludeFlags

  acts_as_paranoid
  audited

  has_many :substance_statutes
  validates_uniqueness_of :name

  def substances
    substance_statutes.map { |ss| ss.substance }.uniq
  end
end
