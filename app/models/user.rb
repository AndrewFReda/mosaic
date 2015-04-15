class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  validates :email, presence: true,
                    # TODO: Email validation is saying everything fails. Figure out why.
                    #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
 
  validates :password, length: { minimum: 1 }

  has_many :pictures, dependent: :destroy

###### NOT IMPLEMENTED ##############
  def add_composition_pictures_from_tempfiles(temps)
    # Check that temps is not nil before iterating
    temps and temps.each do |temp|
      
      @picture = Picture.new
      @picture.set_from_tempfile(temp)
      self.composition_pictures << @picture
    end
  end

  def add_base_pictures_from_tempfiles(temps)
    # Check that temps is not nil before iterating
    temps and temps.each do |temp|

      @picture = Picture.new
      @picture.set_from_tempfile(temp)
      self.base_pictures << @picture
    end
  end

  def add_mosaic_from_IM_image(mosaic)

    name  = "#{DateTime.now.to_s}-mosaic.jpg"
    # TODO: NOT SURE WHERE TO WRITE TO YET...
    path  = "public/images/#{name}"
    mosaic.write(path)

    file     = File.open(path)
    @picture = Picture.new
    @picture.set_from_file(file, name)
    @user.mosaics << @picture    
    file.close
  end

  def delete_composition_pictures(ids)
    delete_pictures(ids, self.composition_pictures)
  end

  def delete_base_pictures(ids)
    delete_pictures(ids, self.base_pictures)
  end

  def delete_mosaics(ids)
    delete_pictures(ids, self.mosaics)
  end

  private
    def delete_pictures(ids, pictures)
      ids.each do |id|
        begin
          pictures.delete(id)
        rescue
          # send error code
        end
      end
    end

end