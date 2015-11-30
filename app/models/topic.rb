class Topic < ActiveRecord::Base
	has_many :questions
<<<<<<< HEAD
=======
	validates :title, presence: true
>>>>>>> list of topics
end
