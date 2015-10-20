require 'wikipedia'

class Substance < ActiveRecord::Base
  acts_as_paranoid
  audited

  belongs_to :substance_classification
  has_many :substance_statutes
  has_many :substance_alternate_names
  has_many :statutes, -> { order 'statutes.start_date ASC' }, { through: :substance_statutes }

  validates_uniqueness_of :name, conditions: -> { where(deleted_at: nil) }
  validates_uniqueness_of :chemical_formula, allow_nil: true, allow_blank: true
  validates_uniqueness_of :chemical_formula_smiles_format, allow_nil: true, allow_blank: true

  def alternate_names
    substance_statutes.map { |ss| ss.substance_alternate_names }.flatten
  end

  def first_regulating_statute
    statutes.first
  end

  def first_scheduled_date
    first_regulating_statute.try(:start_date)
  end

  def federally_scheduled_date
    statutes.select { |s| s.state == Statute::FEDERAL }.first.try(:start_date)
  end

  def regulated_by_statutes(as_of_date = nil)
    raw_statutes = as_of_date ? statutes.select { |s| s.start_date <= as_of_date } : statutes

    if federally_scheduled_date
      federal_inheritors = Statute.where(['duplicate_federal_as_of_date >= ?', federally_scheduled_date])
      if as_of_date && as_of_date >= federally_scheduled_date
        federal_inheritors = federal_inheritors.where(['duplicate_federal_as_of_date <= ?', as_of_date]).all
      end
      raw_statutes += federal_inheritors
    end
    raw_statutes
  end

  def wikipedia_smiles_format
    smiles = wikipedia_info_box.select { |i| i =~ /smiles\s+=/i }.first
    smiles ? smiles.split(' = ').last.strip : nil
  end

  def wikipedia_iupac_format
    iupac = wikipedia_info_box.select { |i| i =~ /IUPAC_*name\s+=/i }.first
    return nil unless iupac
    iupac.split(' = ').last.strip.gsub(/'''|''/, '')
  end

  def wikipedia_info_box
    wikipedia_id = wikipedia_page['query']['pages'].first.first
    info_box_data = wikipedia_page['query']['pages'][wikipedia_id]['revisions'].first['*']
    info_box_data.split("\n")
  end

  def wikipedia_page
    return @wikipedia_json if @wikipedia_json

    json = JSON.parse(Wikipedia.find(name).json)
    if json['query']['pages'].keys.first == '-1'
      return nil unless alternate_names.size > 0

      alternate_names.each do |alternate_name|
        json = JSON.parse(Wikipedia.find(alternate_name.name).json)
        unless json['query']['pages'].keys.first == '-1'
          break
        end
        return nil
      end
    end
    @wikipedia_json = json
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
