class Picture < ActiveRecord::Base
  has_one :histogram, dependent: :destroy

  has_attached_file :image, storage: :s3

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
