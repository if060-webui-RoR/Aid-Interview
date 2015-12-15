FactoryGirl.define do
  factory :question do
    id 200
    content { Faker::Lorem.characters(5) }
    answer  { Faker::Lorem.characters(250) }
    association :topic, factory: :topic, strategy: :build
  end
end
