class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  validates :email, presence: true,
                    # TODO: Email validation is saying everything fails. Figure out why.
                    #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
 
  validates :password, length: { minimum: 1 }

  # Alternatively I can say has_many :pictures then in the Picture class it belongs_to :user
  # I would then need to add another field that indicates the type of picture, or simply create
  # 'getter' methods that select the appropriate picture type
  has_many :composition_pictures, class_name: 'Picture', foreign_key: 'composition_id', dependent: :destroy
  has_many :base_pictures, class_name: 'Picture', foreign_key: 'base_id', dependent: :destroy
  has_many :mosaics, class_name: 'Picture', foreign_key: 'mosaic_id', dependent: :destroy

  # TODO: Explore alternative, I don't like passing session
  def set_session_id(session)
    session[:user_id] = self.id
  end

  def unset_session_id(session)
    session[:user_id] = nil
  end

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