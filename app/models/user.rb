class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
 
  validates :password, length: { minimum: 1 }
  
  has_many :pictures, dependent: :destroy

  def find_pictures_by(attrs = {})
    if attrs[:type]
      self.pictures.where type: attrs[:type]
    elsif attrs[:id]
      self.pictures.where id: attrs[:id]
    else
      self.pictures
    end
  end

end