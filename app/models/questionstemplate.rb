class Questionstemplate < ActiveRecord::Base
  validates :template_id, presence: true
  validates :question_id, presence: true
  validates_uniqueness_of :question_id, scope: :template_id
  belongs_to :template, class_name: Template
  belongs_to :question, class_name: Question
end
