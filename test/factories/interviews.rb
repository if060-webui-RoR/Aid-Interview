FactoryGirl.define do
  factory :interview do
    firstname { Faker::Lorem.characters(50) }
    lastname  { Faker::Lorem.characters(50) }
    target_level 'beginner'
    association :user, factory: :user, strategy: :build
    association :template, factory: :template, strategy: :build
  end
end
