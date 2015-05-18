class Picture < ActiveRecord::Base
  has_one :histogram, dependent: :destroy
  belongs_to :user
  # disable Single Table Inheritance
  self.inheritance_column = :_type_disabled
  
  # On Picture.save, create Image as attachment using Paperclip and store on Amazon S3
  # URL interpretted by Paperclip (see initializers/paperclip.rb)
  has_attached_file :image, :path => '/:user_email/:type/:name', :url => 'https://s3.amazonaws.com/afr-mosaic/:user_email/:type/:name'

  # Validate the attached is an image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :name, :type, presence: true
  validate :type_checker

  before_save :set_url


  def get_content_type
    extension = name.split('.').last
    "image/#{extension}"
  end

  def get_dominant_hue
    set_histogram() if self.histogram.nil? or self.histogram.dominant_hue.nil?

    self.histogram.dominant_hue
  end

  def set_image(image)
    path  = "tmp/#{self.name}"
    image.write(path)
    file       = File.open(image.path)
    self.image = file
    file.close
  end
  private
    def type_checker
      permitted_types = Set.new ['composition', 'base', 'mosaic']
      
      unless permitted_types.include? type
        errors.add(:type, "must be one of: composition, base, mosaic")
      end
    end

    def set_url
      self.url = "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/#{self.user.email}/#{self.type}/#{self.name}"
    end

    def set_histogram
      image = MiniMagick::Image.open(self.url)
      hist  = Histogram.new
      hist.set_hue image: image
      self.histogram = hist
      image.destroy!
    end
end