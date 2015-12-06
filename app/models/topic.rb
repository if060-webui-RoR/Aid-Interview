class Topic < ActiveRecord::Base
	has_many :questions
	validates :title,  presence: true, uniqueness: { case_sensitive: false }
	has_attached_file :image, styles: {thumb: "200x200#"},
	  convert_options: {
      thumb: " -gravity center -crop '200x200+0+0'"
  },
  :default_url => ActionController::Base.helpers.asset_path('no-image.png')
  validates_attachment_size :image, less_than: 2.megabytes
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
