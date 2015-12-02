class Question < ActiveRecord::Base
  belongs_to :topic
  validates :content,  presence: true, uniqueness: { case_sensitive: false }
  validates :topic,    presence: true
  has_many :questionstemplates
  has_many :templates, through: :questionstemplates
end
