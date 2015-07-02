require 'csv'

def parse_schedule_file(schedule_level)
  csv_text = File.read("script/schedule_#{schedule_level}.csv").encode("UTF-8", invalid: :replace, undef: :replace, replace: "?")
  csv_rows = CSV.parse(csv_text, headers: true)

  # Create the schedules
  csv_rows.first.to_hash.keys.select { |k| k =~ /^\d+$/ }.each do |year|
    effective_date = "#{year}-01-01".to_date
    if s = Schedule.where(state: 'FEDERAL', start_date: effective_date).first
      puts "  Already found year #{year}..."
    else
      s = Schedule.new(state: 'FEDERAL', start_date: effective_date)
      s.save
    end
  end

  csv_rows.each do |row|
    row.to_hash.each do |k,v|
      if v.nil? || v == ""
        next
      else
        if v =~ /Effective/i
          substance_name = v.split(" Effective ")[0]
        else
          substance_name = v
        end

        substance = Substance.find_or_create_substance(substance_name)
        schedule = Schedule.where(state: 'FEDERAL', start_date: "#{k}-01-01".to_date).first

        puts "SCHEDULE: #{schedule}"
        ss = SubstanceSchedule.new(substance_id: substance.id, schedule_id: schedule.id, schedule_level: schedule_level)
        ss.save
      end
    end
  end
end

[3,4].each { |i| parse_schedule_file(i) }