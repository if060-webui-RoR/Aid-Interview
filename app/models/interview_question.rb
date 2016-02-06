class InterviewQuestion < ActiveRecord::Base
  MARKS = %w(green yellow red).freeze

  belongs_to :question
  belongs_to :interview
  validates :interview_id, presence: true
  validates :question_id, presence: true
  validates :mark, presence: true, on: :update
  validates :comment, length: { maximum: 255 }
  validates :comment, presence: true, on: :update
end
