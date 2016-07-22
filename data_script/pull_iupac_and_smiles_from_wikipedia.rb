Substance.all.each do |s|
  next unless (s.chemical_formula.blank? || s.chemical_formula_smiles_format.blank?) && s.wikipedia_page
  puts "Looking for #{s.name} with #{s.alternate_names.size} alternate names..."

  if s.chemical_formula.blank?
    if (iupac = s.wikipedia_iupac_format)
      puts "  IUPAC: #{iupac}"
      s.chemical_formula = iupac
      s.save
    end
  end

  if s.chemical_formula_smiles_format.blank?
    if (smiles = s.wikipedia_smiles_format)
      puts "  SMILE: #{smiles}"
      s.chemical_formula_smiles_format = smiles
      s.save
    end
  end
end
