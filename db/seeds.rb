15.times do |n|
  name = "template - #{n + 1}"
  Template.create!(name: name)
end