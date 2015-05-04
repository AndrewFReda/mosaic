class Picture < ActiveRecord::Base
  has_one :histogram, dependent: :destroy
  belongs_to :user
  # disable Single Table Inheritance
  self.inheritance_column = :_type_disabled
  
  # Create Image as attachment to this model using Paperclip.
  # On Picture.save, store on Amazon S3 at url, with path derived from User/Picture keys
  # Interpretted by Paperclip (see initializers/paperclip.rb)
  has_attached_file :image, :path => '/:user_email/:picture_type/:name', :url => 'https://s3.amazonaws.com/afr-mosaic/:user_email/:picture_type/:name'

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :name, :type, presence: true
  validate :type_checker

  def getContentType
    extension = name.split('.').last
    "image/#{extension}"
  end

  private
    def type_checker
      permitted_types = Set.new ['composition', 'base', 'mosaic']
      
      unless permitted_types.include? type
        errors.add(:type, "must be one of: composition, base, mosaic")
      end
    end
end