class Question < ActiveRecord::Base
  belongs_to :topic
  validates :content, presence: true, uniqueness: { case_sensitive: false }
end
