
99.times do |n|
  content = "question - #{n + 1}"
  Question.create!(content: content)
end