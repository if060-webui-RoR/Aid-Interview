class Question < ActiveRecord::Base
  POSSIBLE_LEVELS = ['beginner', 'good', 'strong']

  belongs_to :topic
  has_and_belongs_to_many :templates
  has_many :interview_questions
  validates :content,  presence: true, uniqueness: { case_sensitive: false }
  validates :topic,    presence: true
  validates :level,    presence: true, inclusion: { in: POSSIBLE_LEVELS,
                                       message: "%{value} is not a valid level" }
 
end
