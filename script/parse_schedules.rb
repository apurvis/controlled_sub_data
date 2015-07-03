require 'csv'
require 'Date'

def parse_statute_csv(schedule_level)
  puts "\n\nPARSING SCHEDULE #{schedule_level} FILE"
  puts "=======================================\n"

  csv_text = File.read("script/schedule_data/schedule_#{schedule_level}.csv").encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
  csv_rows = CSV.parse(csv_text, headers: true)

  # Create the schedules
  csv_rows.first.to_hash.keys.select { |k| k =~ /^\d+$/ }.each do |year|
    effective_date = "#{year}-01-01".to_date
    if s = Statute.where(state: 'FEDERAL', start_date: effective_date).first
      puts "  Already found year #{year}..."
    else
      s = Statute.new(state: 'FEDERAL', start_date: effective_date)
      s.save
    end
  end

  current_classification = nil
  csv_rows.each do |row|
    row.to_hash.each do |k,v|
      if v.nil? || v == '' || v =~ /^\d+$/
        next
      elsif k =~ /Controlled Substances Schedule \w/
        # Special handling for the I and II schedule files which include classifications
        current_classification = v.strip
      else
        v = v.strip.gsub(/\s+/, ' ')
        puts "Raw: #{k} => #{v}"

        if v =~ /\(\d\d\d\d\)/
          dea_code = /\((\d\d\d\d)\)/.match(v)[1].to_i
          v.gsub!(/\((\d\d\d\d)\)/, '')
        elsif v =~ /\d\d\d\d$/
          dea_code = /\d\d\d\d$/.match(v)[0].to_i
          v.gsub!(/#{dea_code}$/, '')
          v = v.strip
        end

        first_scheduled_date = nil
        # Sometimes there is date information embedded in the name after "Effective"
        if v =~ /Effective/
          substance_name = v.strip.split("Effective ")[0].strip
          first_scheduled_date = v.strip.split("Effective ")[1].strip
          puts "Effective: #{first_scheduled_date}"
          if first_scheduled_date =~ /^\d+\/\d+\/\d\d\d\d$/
            first_scheduled_date = Date.strptime(first_scheduled_date, "%m/%d/%Y")
          else
            first_scheduled_date = Date.parse(first_scheduled_date) rescue nil
          end
        else
          substance_name = v.strip
        end

        #... but sometimes it's just there as (December 1, 1980) or (Jul 3, 1972)
        # We err on the side of the last 25 chars because there can be a lot of parens otherwise
        last_25_chars = substance_name[substance_name.size - 25..substance_name.size]
        if last_25_chars =~ /\(.*\)/
          possible_date_string = /\((.*)\)/.match(last_25_chars)[1]
          if (Date.parse(possible_date_string) rescue nil)
            first_scheduled_date = Date.parse(possible_date_string)
            puts "Parsed #{first_scheduled_date} out of #{v}!"
            substance_name = substance_name.gsub(/\(#{possible_date_string}\)/, '').strip rescue substance_name
            puts "   Afterwards reduced to #{substance_name}"
          end
        end

        substance = Substance.find_or_create_substance(
          substance_name,
          classification: current_classification,
          dea_code: dea_code,
          first_scheduled_date: first_scheduled_date
        )

        if statute = Statute.where(state: 'FEDERAL', start_date: "#{k.strip}-01-01".to_date).first
          if SubstanceStatute.where(substance_id: substance.id, statute_id: statute.id, schedule_level: schedule_level).size > 0
            puts "Already have a statute for #{substance_name}, #{statute.start_date}, #{schedule_level}"
          else
            ss = SubstanceStatute.new(substance_id: substance.id, statute_id: statute.id, schedule_level: schedule_level)
            ss.save
          end
        else
          raise "Statute not found for #{k}!"
        end
      end
    end
  end
end

[1,2,3,4,5].each { |i| parse_statute_csv(i) }
