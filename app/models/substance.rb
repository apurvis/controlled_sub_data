class Substance < ActiveRecord::Base
  belongs_to :substance_classification
  has_many :substance_statutes

  validates_uniqueness_of :name
  validates_uniqueness_of :dea_code, :allow_nil
  validates_uniqueness_of :chemical_formula
  validates_uniqueness_of :chemical_formula_smiles_format

  def self.find_or_create_substance(name, options = {})
    s = nil
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
    s.save
    s
  end
end
