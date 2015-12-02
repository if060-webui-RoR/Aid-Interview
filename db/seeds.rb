# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

template =  Template.create!(name: 'Something')
template1 = Template.create!(name: 'Somewhere')

admin = User.create!(first_name: 'admin', last_name: 'admin', email: 'admin@admin.com', password: '12345678', admin: true, approved: true)

Topic.create!(title: "Outside any topic") #DO NOT DELETE! NECESSARY FOR TOPICS WORK!

topic = Topic.create!(title: 'some')
topic1 = Topic.create!(title: 'visible')

35.times do |n|
  content = "question - #{n + 1}"
  @question = Question.create!(topic: topic,
                               content: content,
                               answer: 'Answer')
end

template.questionstemplates.create!(question: Question.first)
template.questionstemplates.create!(question: Question.second)