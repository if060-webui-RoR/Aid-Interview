class InterviewQuestion < ActiveRecord::Base
  MARKS = ['GREEN', 'YELLOW', 'RED']
  belongs_to :interview
  belongs_to :question
  validates :interview_id, presence: true
  validates :question_id, presence: true
end
