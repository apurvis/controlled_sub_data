class SubstanceClassification < ActiveRecord::Base
  acts_as_paranoid

  has_many :substances

  validates_uniqueness_of :name

  def self.find_or_create_substance_classification(name)
    s = SubstanceClassification.where(name: name).first
    s = SubstanceClassification.new(name: name) unless s

    s.save
    s
  end
end
