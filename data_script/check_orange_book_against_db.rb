File.open('data_script/orange_book.txt') do |file|

  file.each do |line|
    if line =~ /\*/
      puts "SKIPPING: #{line}"
      next
    end

    substance, rest = line.split(/\d\d-\d\d-\d\d/)
    substance = substance.strip.downcase
#    puts "Checking #{substance}...}"
    if Substance.where("LOWER(name) = '#{substance}'").first.nil? && SubstanceAlternateName.where("LOWER(name) = '#{substance}'").first.nil?
      puts "   NOT FOUND #{substance}!"
    end

  end
end
