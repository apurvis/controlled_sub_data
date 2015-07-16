class StatuteAmendment < ActiveRecord::Base
  belongs_to :statute
  has_many :statute_amendment_substance_changes

  def formatted_name
    if start_date
      "#{statute.formatted_name} Amended #{start_date.strftime('%Y-%m-%d')}"
    else
      "#{statute.formatted_name} Amended XXXX-XX-XX"
    end
  end
end
