FactoryGirl.define do
  factory :federal_statute, class: Statute do
    state Statute::FEDERAL
    start_date '1970-01-01'.to_date
    after(:create) do |statute, evaluator|
      create(:substance_statute, statute: statute, substance: build(:substance))
    end
  end



#  after(:create) do |user, evaluator|
#    create_list(:post, evaluator.posts_count, user: user)
#  end

#  factory :statute do
#    state 'NY'
#    name 'test statute'
#    start_date '1980-08-01'
#  end
end
