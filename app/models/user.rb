class User < ActiveRecord::Base
  has_many :templates
  has_many :questions,
           through :template

end
