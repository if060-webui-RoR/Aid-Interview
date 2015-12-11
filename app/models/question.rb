class Question < ActiveRecord::Base
  belongs_to :topic
  validates :content,  presence: true, uniqueness: { case_sensitive: false }
  validates :topic,    presence: true
  has_and_belongs_to_many :templates
end
