class Statute < ActiveRecord::Base
  acts_as_paranoid

  has_many :substance_statutes
  has_many :statute_amendments, foreign_key: :parent_id

  validates :state, presence: true, length: { minimum: 2 }
  validates :start_date, presence: true

  STATES = ['REVAMPED_FEDERAL', 'FEDERAL', 'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']

  def duplicated_federal_substance_statutes
    if duplicate_federal_as_of_date
      Statute.where(state: 'REVAMPED_FEDERAL').where(['start_date <= ?', duplicate_federal_as_of_date]).map do |s|
        s.substance_statutes
      end.flatten.compact
    else
      []
    end
  end

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
