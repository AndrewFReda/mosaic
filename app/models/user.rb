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

  def set_session_id
    session[:user_id] = self.id
  end

  def unset_session_id
    session[:user_id] = nil
  end
    end
  end

  def set_session_id()
    session[:user_id] = @id
  end

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