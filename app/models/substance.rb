class Substance < ActiveRecord::Base
  def self.find_or_create_substance(name, options = {})
    s = nil
    if s = Substance.where(name: name).first
      puts "  Skipping #{name} because it already exists with id #{Substance.where(name: name).first.id}"
    else
      puts "  Creating substance record #{name}"
      s = Substance.new(name: name)
    end

    s.classification = options[:classification] if options[:classification]
    s.save
    s
  end
end
