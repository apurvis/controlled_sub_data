Substance.all.each do |s|
  next unless (s.chemical_formula.blank? || s.chemical_formula_smiles_format.blank?) && s.wikipedia_page
  puts "Looking for #{s.name} with #{s.alternate_names.size} alternate names..."

  if s.chemical_formula.blank?
    puts "  IUPAC: #{s.wikipedia_iupac_format}"
    s.chemical_formula = s.wikipedia_iupac_format
  end

  if s.chemical_formula_smiles_format.blank?
    puts "  SMILE: #{s.wikipedia_smiles_format}"
    s.chemical_formula_smiles_format = s.wikipedia_smiles_format
  end

  s.save
end
