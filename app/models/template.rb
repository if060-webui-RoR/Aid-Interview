class Template < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :questionstemplates
  has_many :questions, through: :questionstemplates
end
