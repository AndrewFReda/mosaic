class Picture < ActiveRecord::Base
  has_one :histogram, dependent: :destroy

  has_attached_file :image, :path => '/:user_email/:picture_type/:name', :url => 'https://s3.amazonaws.com/afr-mosaic/:user_email/:picture_type/:name'

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
