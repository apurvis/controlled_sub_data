FactoryGirl.define do
  factory :substance do
    sequence(:name) { |n| "euro_#{n}" }
  end
end
