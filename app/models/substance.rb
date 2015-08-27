class Substance < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :substance_classification
  has_many :substance_statutes
  has_many :substance_alternate_names
  has_many :statutes, { through: :substance_statutes }, -> { order 'statutes.started_at ASC' }

  validates_uniqueness_of :name
  validates_uniqueness_of :chemical_formula, allow_nil: true, allow_blank: true
  validates_uniqueness_of :chemical_formula_smiles_format, allow_nil: true, allow_blank: true

  def first_regulating_statute
    statutes.first
  end

  def first_scheduled_date
    first_regulating_statute.try(:start_date)
  end

  def regulated_by_statutes(as_of_date = nil)
    raw_statutes = as_of_date ? statutes.select { |s| s.start_date <= as_of_date } : statutes

    if raw_statutes.any? { |s| s.state == Statute::FEDERAL }
      federally_scheduled_date = raw_statutes.select { |s| s.state == Statute::FEDERAL }.first.start_date
      if as_of_date && as_of_date >= federally_scheduled_date
        federal_inheritors = Statute.where(['duplicate_federal_as_of_date <= ?', as_of_date]).all
      else
        federal_inheritors = Statute.where(['duplicate_federal_as_of_date IS NOT NULL AND duplicate_federal_as_of_date >= ?', federally_scheduled_date]).all
      end
      raw_statutes += federal_inheritors
    end
    raw_statutes
  end

  def self.find_or_create_substance(name, options = {})
    s = nil
    name = name.strip
    s = Substance.where(name: name).first
    s = Substance.new(name: name) unless s

    if options[:classification]
      s.substance_classification_id = SubstanceClassification.find_or_create_substance_classification(options[:classification]).id
    end

    s.dea_code = options[:dea_code] if options[:dea_code]
    s.save

    s
  end
end
