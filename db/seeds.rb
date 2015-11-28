topic = Topic.create!(title: 'some', string: 'something')
topic1 = Topic.create!(title: 'visible', string: 'crash')

99.times do |n|
  content = "question - #{n + 1}"
  Question.create!(topic: topic, content: content)
end