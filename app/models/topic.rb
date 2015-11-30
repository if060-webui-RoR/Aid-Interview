class Topic < ActiveRecord::Base
	has_many :questions
<<<<<<< HEAD
	validates :title, presence: true

=======
>>>>>>> 13ae2cecb236cc0c31c78ccb539779c952c6ce2b
end
