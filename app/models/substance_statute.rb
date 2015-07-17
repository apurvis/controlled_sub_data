class SubstanceStatute < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :substance
  belongs_to :statute

  scope :additions, -> { where(is_expiration: false) }
  scope :expirations, -> { where(is_expiration: true) }

  def expiring_amendment
    puts "floozby amendments: #{statute.statute.statute_amendments.size}"
    puts "statute id: #{statute.statute.id}, selfid: #{self.id}"
    SubstanceStatute.expirations.where(
      statute_id: statute.statute.statute_amendments.map { |a| a.id },
      substance_id: substance.id
    ).first.try(:statute)
  end

  def expiration_date
    expiring_amendment.try(:start_date)
  end
end
