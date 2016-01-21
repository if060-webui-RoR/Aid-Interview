class Template < ActiveRecord::Base
  has_and_belongs_to_many :questions
  belongs_to :user
  has_many :interviews
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
