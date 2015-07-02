class SubstanceSchedule < ActiveRecord::Base
  belongs_to :substance
  belongs_to :schedule
  #select s.name, state, start_date from substance_schedules ss join substances s on s.id=ss.substance_id join schedules sc on sc.id=ss.schedule_id;
end
