class SubstanceStatute < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :substance
  belongs_to :statute
  has_many :substance_alternate_names

  scope :additions, -> { where(is_expiration: false) }
  scope :expirations, -> { where(is_expiration: true) }

  def expiring_amendment
    base_statute = (statute.statute rescue nil) || statute

    SubstanceStatute.expirations.where(
      statute_id: base_statute.statute_amendments.map { |a| a.id },
      substance_id: substance.id
    ).first.try(:statute)
  end

  def expiration_date
    expiring_amendment.try(:start_date)
  end
end
