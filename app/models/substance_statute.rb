class SubstanceStatute < ActiveRecord::Base
  include IncludeFlags

  acts_as_paranoid
  audited

  belongs_to :substance, inverse_of: :substance_statutes
  belongs_to :statute, inverse_of: :substance_statutes
  belongs_to :substance_classification, inverse_of: :substance_statutes
  has_many :substance_alternate_names

  scope :additions,   -> { where('is_expiration = FALSE OR is_expiration IS NULL') }
  scope :expirations, -> { where(is_expiration: true) }

  DIFFERENT_SUBSTANCES = 'Different substances'
  DIFFERENT_SALTS = 'Extra salt/isomer flags'

  # This won't really work in the case where a substance is added, then expired, then added again
  def expiring_amendment(options = {})
    expiring_substance_statute(options).try(:statute)
  end

  def expiration_date
    expiring_amendment.try(:start_date) || statute.expiration_date
  end

  def expiring_substance_statute(options = {})
    return nil if is_expiration

    base_statute = (statute.statute rescue nil) || statute
    expiring_statutes = SubstanceStatute.expirations.joins(:statute).where(
      substance_id: substance.id,
      statute_id: base_statute.statute_amendments.map { |a| a.id }
    ).where(['statutes.start_date > ?', statute.start_date])

    if options[:as_of]
      expiring_statutes = expiring_statutes.where(['start_date <= ?', options[:as_of]])
    end

    expiring_statutes.first
  end

  def regulates_same_as?(substance_statute)
    regulation_differences(substance_statute).empty?
  end

  # Comparison method
  def regulation_differences(substance_statute, options = {})
    return [DIFFERENT_SUBSTANCES] if substance_id != substance_statute.substance_id

    other_include_flags = substance_statute.include_flags(options)
    if include_flags(options).all? { |f| other_include_flags.include?(f) }
      []
    else
      [DIFFERENT_SALTS]
    end
  end

  # These are the ones that come from the classification, not the SubstanceStatute itself
  def derived_include_flags(options = {})
    return [] unless substance_classification.try(:in_effect_as_of?, options[:as_of])

    substance_classification.include_flags
  end
end
