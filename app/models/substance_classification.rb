class SubstanceClassification < ActiveRecord::Base
  def self.find_or_create_substance_classification(name)
    s = nil
    if s = SubstanceClassification.where(name: name).first
      puts "  Skipping #{name} because it already exists with id #{SubstanceClassification.where(name: name).first.id}"
    else
      puts "  Creating substance record #{name}"
      s = SubstanceClassification.new(name: name)
    end

    s.save
    s
  end
end
