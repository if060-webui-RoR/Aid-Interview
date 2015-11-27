class Question < ActiveRecord::Base
  validates :content, presence: true
  belongs_to :topic
  validates :topic_id, presence: true
end
