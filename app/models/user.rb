class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  validates :email, presence: true,
                    # TODO: Email validation is saying everything fails. Figure out why.
                    #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
 
  validates :password, length: { minimum: 1 }
  
  has_many :pictures, dependent: :destroy

  def find_pictures_by(attrs)
    if attrs[:type]
      self.pictures.where type: attrs[:type]
    else
      self.pictures
    end
  end

end