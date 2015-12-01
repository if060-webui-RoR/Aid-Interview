# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

topic = Topic.create!(title: 'some')
topic1 = Topic.create!(title: 'visible')

99.times do |n|
  content = "question - #{n + 1}"
  Question.create!(topic: topic, content: content, answer: 'Answer')
end