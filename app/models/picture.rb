class Picture < ActiveRecord::Base
  has_one :histogram, dependent: :destroy
  belongs_to :user
  # disable Single Table Inheritance
  self.inheritance_column = :_type_disabled
  
  # On Picture.save, create Image as attachment using Paperclip and store on Amazon S3
  # URL interpretted by Paperclip (see initializers/paperclip.rb)
  has_attached_file :image, :path => '/:user_email/:type/:name', :url => 'https://s3.amazonaws.com/afr-mosaic/:user_email/:type/:name'

  # Validate the attached image is image/jpg, image/png, etc
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

  # TODO: Important!
  # =>  Elimnates URL field but means updating pictures needs to update S3 or links will break
  def get_url
    "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/#{self.user.email}/#{self.type}/#{self.name}"
  end

  def set_image(image)
    path  = "public/images/#{self.name}"
    
    image.write(path)
    file       = File.open(path)
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
      self.url = get_url
    end

    def set_histogram
      # Download file and open in File object
      file  = File.open(open(URI::encode(self.get_url())))
      image = Image.read(file).first
      hist  = Histogram.new
      hist.set_hue image: image
      self.histogram = hist
      file.close
    end
end