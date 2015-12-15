class Template < ActiveRecord::Base
  has_and_belongs_to_many :questions
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end