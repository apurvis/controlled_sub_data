class Statute < ActiveRecord::Base
  acts_as_paranoid
  audited

  has_many :substance_statutes
  has_many :statute_amendments, -> { order(:start_date) }, { foreign_key: :parent_id, inverse_of: :statute }

  validates :state, presence: true, length: { minimum: 2 }
  validates :start_date, presence: true

  FEDERAL = 'FEDERAL'
  STATES = [FEDERAL, 'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']

  def effective_substance_statutes_info_hash(options = {})
    regulations = effective_substance_statutes(options.merge(keep_all: true))
    regulations.map do |ss|
      added_by_amendment = nil
      if duplicate_federal_as_of_date && ss.statute.federal?
        added_by_amendment = 'Inherited Federal'
      elsif ss.statute == self
        added_by_amendment = "This #{ss.statute.class.to_s}"
      elsif ss.statute.is_a?(StatuteAmendment)
        added_by_amendment = ss.statute
      end

      expired_by_amendment = regulations.select { |r| r.is_expiration? && r.substance_id == ss.substance_id && r.statute.start_date > ss.statute.start_date }.first.try(:statute)
      if expired_by_amendment
        expiration_string = "Explicit Removal by #{expired_by_amendment.formatted_name}"
      elsif ss.expiration_date
        expired_by_amendment ||= ss.statute
        expiration_string = "#{ss.expiration_date.strftime('%Y-%m-%d')} Expiration of #{ss.statute.formatted_name}"
      end

      effective_date = (ss.statute.federal? && duplicate_federal_as_of_date) ? duplicate_federal_as_of_date : ss.statute.start_date

      {
        substance_statute: ss,
        substance: ss.substance,
        start_date: effective_date,
        added_by_amendment: added_by_amendment,
        is_expiration: ss.is_expiration?,
        expired_by_amendment: expired_by_amendment,
        expiration_string: expiration_string,
        schedule_level: ss.schedule_level,
        comment: ss.comment
      }
    end.sort do |a,b|
      if a[:start_date] < b[:start_date]
        -1
      elsif a[:start_date] > b[:start_date]
        1
      else
        a[:substance].name <=> b[:substance].name
      end
    end
  end

  # Pass an :as_of param to limit results by date
  # Pass the :keep_all option to avoid stripping out overridden regulations (moving from schedule II to III, for instance),
  # expired statutes, and the expiring amendments themselves
  def effective_substance_statutes(options = {})
    regulations = substance_statutes + duplicated_federal_substance_statutes(options)
    amendments = statute_amendments.select { |a| !options[:as_of] || a.start_date <= options[:as_of] }

    if options[:keep_all]
      regulations + amendments.map { |a| a.substance_statutes }.flatten
    else
      if options[:as_of]
        amendments.select! { |a| !a.expiration_date || a.expiration_date > options[:as_of] }
      else
        amendments.select! { |a| !a.expiration_date || a.expiration_date > Date.today }
      end
      regulations += amendments.map { |a| a.substance_statutes }.flatten
      reject_expired_and_replaced(regulations)
    end
  end

  def duplicated_federal_substance_statutes(options = {})
    duplicated_federal_statutes(options).map { |s| s.substance_statutes }.flatten
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

  def federal?
    state == FEDERAL
  end

  private

  # First strip out the substance_statutes that have a later expiration in the regulations set
  # Then strip out the actual expiration substance_statutes
  # Finally take only the last substance_statute by statute_id to be the valid one.
  def reject_expired_and_replaced(regulations)
    reject_replaced(reject_expired(regulations)).sort { |a,b| a.statute.start_date <=> b.statute.start_date }
  end

  def reject_expired(regulations)
    regulations.reject { |ss| regulations.any? { |s| s.is_expiration? && ss.substance_id == s.substance_id && s.statute.start_date > ss.statute.start_date } }
               .reject { |ss| ss.is_expiration? }
  end

  def reject_replaced(regulations)
    regulations.reject { |ss| regulations.any? { |s| !s.is_expiration? && ss.substance_id == s.substance_id && s.statute.start_date > ss.statute.start_date } }
  end
end
