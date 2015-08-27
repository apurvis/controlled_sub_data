SubstanceAlternateName.all.each do |name|
  if name.substance.first_regulating_statute
    link = name.substance.first_regulating_statute.substance_statutes.select { |ss| ss.substance_id == name.substance_id }.first
    puts "#{name.name} first scheduled on #{name.substance.first_regulating_statute.formatted_name}, link #{link.id}"
    name.substance_statute_id = link.id
    name.substance_id = nil
    name.save
  else
    puts "Cannot find any regulation for #{name.name}; leaving attached to #{name.substance.name}"
  end
end
