FactoryGirl.define do
  factory :federal_statute, class: Statute do
    state Statute::FEDERAL
    start_date '1970-01-01'.to_date

    after(:create) do |statute, evaluator|
      create(:substance_statute, statute: statute, substance: build(:substance))
    end
  end

  factory :state_statute, class: Statute do
    state 'NY'
    start_date '1980-08-01'

    after(:create) do |statute, evaluator|
      create(:substance_statute, statute: statute, substance: build(:substance))
    end
  end
end
