class StatuteAmendment < Statute
  belongs_to :statute, foreign_key: :parent_id

  def formatted_name
    if start_date
      "#{start_date.strftime('%Y-%m-%d')} Amendment to #{statute.formatted_name}"
    else
      "#{statute.formatted_name} Amended XXXX-XX-XX"
    end
  end
end
