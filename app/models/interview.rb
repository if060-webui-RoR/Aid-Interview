class Interview < ActiveRecord::Base
  TARGET_LEVELS = %w(beginner intermediate advanced).freeze

  belongs_to :template
  belongs_to :user
  has_many :interview_questions
  has_many :questions, through: :template
  validates :lastname, :firstname, presence: true, length: { maximum: 55 }
  validates :template_id, presence: true
  validates :target_level, presence: true, inclusion: { in: TARGET_LEVELS, message: "%{value} is not a valid level" }

  def not_answered_first_question
    interview_questions.where('mark IS NULL').first
  end

  def not_answered_questions
    interview_questions.where('mark IS NOT NULL').count
  end

  def next_interview_question(question)
    interview_questions.order(id: :asc).where("id > ?", question.id).first
  end

  def sequence_number(question)
    interview_questions.order(id: :asc).index(question) + 1
  end

  def question_number(question)
    number = sequence_number(question)
    number = number.to_s + 'c' unless question.comment.blank?
    number
  end

  def valid_mark(question)
    next_question = question
    next_question = not_answered_first_question if question.mark.blank?
    next_question
  end
end
