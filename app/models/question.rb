class Question < ActiveRecord::Base
  belongs_to :topic
  has_and_belongs_to_many :templates
  validates :content,  presence: true, uniqueness: { case_sensitive: false }
  validates :topic,    presence: true
end
