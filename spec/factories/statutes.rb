FactoryGirl.define do
  factory :statute do
    factory :federal_statute do
      start_date '1980-01-01'.to_date
      blue_book_code 'federal 1'
    end
  end
end
