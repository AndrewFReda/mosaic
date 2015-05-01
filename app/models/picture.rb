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
  validates :name, presence: true


  def getContentType
    extension = name.split('.').last
    "image/#{extension}"
  end

###### NOT IMPLEMENTED ##############
  def set_from_tempfile(temp)
    file  = File.open(temp.tempfile)
    fname = "#{DateTime.now.to_s}-#{temp.original_filename}"    
    set_from_file(file, fname)
    file.close
  end

  def set_from_file(file, fname)
    self.name  = fname
    self.image = file
    
    self.histogram = Histogram.new
    img            = Image.read(file).first    
    self.histogram.set_hue_from_image(img)
  end
end