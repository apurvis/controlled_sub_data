class SubstanceClassification < ActiveRecord::Base
  include IncludeFlags

  acts_as_paranoid
  audited

  has_many :substance_statutes
  belongs_to :statute, inverse_of: :substance_classifications
  validates_uniqueness_of :name

  def substances
    substance_statutes.map { |ss| ss.substance }.uniq.sort { |a,b| a.name <=> b.name }
  end
end
