class Substance < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :substance_classification
  has_many :substance_statutes
  has_many :substance_alternate_names

  validates_uniqueness_of :name
#  validates_uniqueness_of :dea_code, allow_nil: true TODO: should be on
  validates_uniqueness_of :chemical_formula, allow_nil: true, allow_blank: true
  validates_uniqueness_of :chemical_formula_smiles_format, allow_nil: true, allow_blank: true

  def self.find_or_create_substance(name, options = {})
    s = nil
    name = name.strip
    if s = Substance.where(name: name).first
      puts "  Skipping #{name} because it already exists with id #{Substance.where(name: name).first.id}"
    else
      puts "  Creating substance record #{name}"
      s = Substance.new(name: name)
    end

    if options[:classification]
      s.substance_classification_id = SubstanceClassification.find_or_create_substance_classification(options[:classification]).id
    end

    s.dea_code = options[:dea_code] if options[:dea_code]
    s.first_scheduled_date = options[:first_scheduled_date] if options[:first_scheduled_date]
    s.save

    s
  end
end
