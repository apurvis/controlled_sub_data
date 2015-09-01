class Statute < ActiveRecord::Base
  acts_as_paranoid
  audited

  has_many :substance_statutes
  has_many :statute_amendments, -> { order(:start_date) }, { foreign_key: :parent_id, inverse_of: :statute }

  validates :state, presence: true, length: { minimum: 2 }
  validates :start_date, presence: true

  FEDERAL = 'FEDERAL'

  STATES = [FEDERAL, 'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']

  def effective_substance_statutes(options = {})
    substance_statutes = substance_statutes + duplicated_federal_substance_statutes(options)
    substance_statutes += @statute.statute_amendments.map { |amendment| amendment.substance_statutes }.flatten
    substance_statutes.reject { |ss| substance_statutes.any? { |s| s.is_expiration? && ss.substance_id == s.substance_id } }
  end

  def duplicated_federal_substance_statutes(options = {})
    substance_statutes = duplicated_federal_statutes(options).map { |s| s.substance_statutes }.flatten.compact
    substance_statutes.reject { |ss| substance_statutes.any? { |s| s.is_expiration? && ss.substance_id == s.substance_id } }
  end

  def duplicated_federal_statutes(options = {})
    if duplicate_federal_as_of_date
      statutes = Statute.where(state: FEDERAL).where(['start_date <= ?', duplicate_federal_as_of_date]).all
      options[:as_of] ? statutes.select { |s| s.start_date <= options[:as_of] } : statutes
    else
      []
    end
  end

  def formatted_name
    if start_date
      "#{state}/#{start_date.strftime('%Y-%m-%d')}"
    else
      "#{state}/XXXX-XX-XX"
    end
  end
end
