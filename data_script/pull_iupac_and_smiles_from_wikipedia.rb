Substance.all.each do |s|
  puts "Looking for #{s.name} with #{s.alternate_names.size} alternate names..."
  if s.wikipedia_page
    puts "  IUPAC: #{s.wikipedia_iupac_format}"
    if s.chemical_formula.blank?
      s.chemical_formula = s.wikipedia_iupac_format
    end

    puts "  SMILE: #{s.wikipedia_smiles_format}"
    if s.chemical_formula_smiles_format.blank?
      s.chemical_formula_smiles_format = s.wikipedia_smiles_format
    end
    s.save
  else
    puts "  No wikipedia page info found"
  end
end
