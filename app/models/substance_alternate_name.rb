class SubstanceAlternateName < ActiveRecord::Base
  acts_as_paranoid
  audited

  # should probably delegate through substance_statute as having a substance_id in a SubstanceAlternateName is
  # deprecated
  belongs_to :substance
  belongs_to :substance_statute, inverse_of: :substance_alternate_names

  validates :name, presence: true

  delegate :statute, to: :substance_statute, allow_nil: true
end
