class Substance < ActiveRecord::Base
  def self.find_or_create_substance(name)
    if s = Substance.where(name: name).first
      puts "  Skipping #{name} because it already exists with id #{Substance.where(name: name).first.id}"
      s
    else
      puts "  Creating substance record #{name}"
      s = Substance.new(name: name)
      s.save
      s
    end
  end
end
