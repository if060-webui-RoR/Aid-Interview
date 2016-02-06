class Question < ActiveRecord::Base
  belongs_to :topic
  has_and_belongs_to_many :templates
  validates :content,  presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 65_535 }
  validates :answer,   presence: true, length: { maximum: 65_535 }
  validates :topic,    presence: true
  validates :level,    presence: true, inclusion: { in: 0..2, message: " is not valid" }
end
