class Interview < ActiveRecord::Base
  TARGET_LEVELS = %w(beginner intermediate advanced)

  belongs_to :template
  belongs_to :user
  has_many :interview_questions
  has_many :questions, through: :template
  validates :lastname, :firstname, presence: true
  validates :template_id, presence: true
  validates :target_level, presence: true, inclusion: { in: TARGET_LEVELS, message: "%{value} is not a valid level" }
end
