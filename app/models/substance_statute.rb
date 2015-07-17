class SubstanceStatute < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :substance
  belongs_to :statute

  def expiring_amendment
    SubstanceStatute.where(
      statute_id: statute.statute_amendments.map { |a| a.id },
      substance_id: substance.id,
      is_expiration: true
    ).first.try(:statute)
  end

  def expiration_date
    expiring_amendment.try(:start_date)
  end
end
