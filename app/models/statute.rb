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
    regulations = substance_statutes + duplicated_federal_substance_statutes(options)
    regulations += statute_amendments.select { |a| !options[:as_of] || a.start_date <= options[:as_of] }
                                     .map { |a| a.substance_statutes }
                                     .flatten
    reject_expired_and_replaced(regulations)
  end

  def duplicated_federal_substance_statutes(options = {})
    regulations = duplicated_federal_statutes(options).map { |s| s.substance_statutes }.flatten
    reject_expired_and_replaced(regulations)
  end

  def duplicated_federal_statutes(options = {})
    if duplicate_federal_as_of_date
      statutes = Statute.where(state: FEDERAL).where(['start_date <= ?', duplicate_federal_as_of_date])
      if options[:as_of]
        statutes = statutes.where(['start_date <= ?', options[:as_of]])
      end
      statutes.all
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

  private

  # First strip out the substance_statutes that have a later expiration in the regulations set
  # Then strip out the actual expiration substance_statutes
  # Finally take only the last substance_statute by statute_id to be the valid one.
  def reject_expired_and_replaced(regulations)
    regulations.reject { |ss| regulations.any? { |s| s.is_expiration? && ss.substance_id == s.substance_id && s.statute.start_date > ss.statute.start_date } }
               .reject { |ss| ss.is_expiration? }
               .reject { |ss| regulations.any? { |s| ss.substance_id == s.substance_id && s.statute.start_date > ss.statute.start_date } }
               .sort { |a,b| a.statute.start_date <=> b.statute.start_date }
  end
end
