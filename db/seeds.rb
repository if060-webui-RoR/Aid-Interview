# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create!(first_name: 'admin', last_name: 'admin', email: 'admin@admin.com', password: '12345678', admin: true, approved: true)

Topic.create!(title: "Outside any topic") #DO NOT DELETE! NECESSARY FOR TOPICS WORK!

topic = Topic.create!(title: 'some')

35.times do |n|
  content = "question - #{n + 1}"
  Question.create!(topic: topic, content: content, answer: 'Answer')
end

User.create!(first_name:  'admin',
              last_name:   'admin',      
              email:       'a@a.a',
              password:    '12345678',
              admin:       true,
              approved:    true
      
  )
User.create!(first_name:  'interviewer',
              last_name:   'approveeeed',      
              email:       'b@b.b',
              password:    '12345678',
              admin:       false,
              approved:    true
      
  )
User.create!(first_name:  'interviewer',
              last_name:   'not_approveeeed',      
              email:       'c@c.c',
              password:    '12345678',
              admin:       false,
              approved:    false
      
  )
