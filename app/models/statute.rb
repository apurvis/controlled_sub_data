class Statute < ActiveRecord::Base
  has_many :substance_statutes

  validates :state, presence: true, length: { minimum: 2 }
  validate :has_valid_start_date

  private
  def has_valid_start_date
    begin
      start_date.to_date
    rescue
      errors.add(:has_valid_start_date, "Can't parse #{start_date}")
    end
  end
end
