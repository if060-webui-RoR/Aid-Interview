class Question < ActiveRecord::Base
	belongs_to :topic
	validates :content, presence: true
<<<<<<< HEAD

=======
>>>>>>> 13ae2cecb236cc0c31c78ccb539779c952c6ce2b
end
