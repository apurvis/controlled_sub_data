class StatuteAmendment < Statute
  belongs_to :statute, foreign_key: :parent_id

  def formatted_name
    if start_date
      "#{statute.formatted_name} Amended #{start_date.strftime('%Y-%m-%d')}"
    else
      "#{statute.formatted_name} Amended XXXX-XX-XX"
    end
  end
end
