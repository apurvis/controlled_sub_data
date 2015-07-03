class Statute < ActiveRecord::Base
  acts_as_paranoid

  has_many :substance_statutes

  validates :state, presence: true, length: { minimum: 2 }
  validates :start_date, presence: true

  def formatted_name
    if start_date
      "#{state}/#{start_date.strftime('%Y-%m-%d')}"
    else
      "#{state}/XXXX-XX-XX"
    end
  end

  private
  def has_valid_start_date
    begin
      start_date.to_date
    rescue
      errors.add(:has_valid_start_date, "Can't parse #{start_date}")
    end
  end
end
