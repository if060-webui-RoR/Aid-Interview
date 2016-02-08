FactoryGirl.define do
  factory :interview_question do
    comment { Faker::Lorem.characters(250) }
    mark 'green'
    association :interview, factory: :interview, firstname: 'John'
    association :question, factory: :question, strategy: :build
  end
end
