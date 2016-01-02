class Interview < ActiveRecord::Base
  belongs_to :template
  belongs_to :user
  has_many :interview_questions
  has_many :questions, through: :template
  validates :lastname, :firstname, presence: true
  validates :template_id, presence: true
  validates :target_level, presence: true, inclusion: { in: 0..2, message: " is not valid" }

  def t_level
    POSSIBLE_LEVELS[target_level]
  end
end
