class SubstanceStatute < ActiveRecord::Base
  belongs_to :substance
  belongs_to :statute
  #select s.name, state, start_date, schedule_level from substance_statutes ss join substances s on s.id=ss.substance_id join statutes sc on sc.id=ss.statute_id;
end
