class SubstanceStatute < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :substance
  belongs_to :statute
  has_many :substance_alternate_names

  scope :additions, -> { where(is_expiration: false) }
  scope :expirations, -> { where(is_expiration: true) }

  DIFFERENT_SUBSTANCES = 'Different substances'
  DIFFERENT_SALTS = 'Different salt/isomer flags'
  DIFFERENT_SCHEDULE = 'Different schedule levels'

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

  def include_flags_string
    include_flags.map { |f| f.sub(/^include_/, '').humanize }.join(', ')
  end

  def has_include_flags?
    include_flags.size > 0
  end

  def regulates_same_as?(substance_statute)
    regulation_differences(substance_statute).empty?
  end

  # Comparison method
  def regulation_differences(substance_statute)
    differences = []
    if substance_id != substance_statute.substance_id
      differences << DIFFERENT_SUBSTANCES
    else
      differences << DIFFERENT_SALTS unless include_flags.sort == substance_statute.include_flags.sort
      differences << DIFFERENT_SCHEDULE unless schedule_level == substance_statute.schedule_level
    end

    differences
  end

  protected

  def include_flags
    self.attributes.select { |k,v| k =~ /^include_/ && v == true }.keys
  end
end
