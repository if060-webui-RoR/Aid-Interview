FactoryGirl.define do
  factory :interview_question do
    id 224
    interview_id 155
    question_id 7
    comment { Faker::Lorem.characters(250) }
    mark 'green'
  end
end
