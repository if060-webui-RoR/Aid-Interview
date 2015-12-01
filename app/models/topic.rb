class Topic < ActiveRecord::Base
	has_many :questions
	validates :title,  presence: true, uniqueness: { case_sensitive: false }
end
