class User < ActiveRecord::Base
  has_secure_password
  has_many :pictures, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
 
  validates :password, length: { minimum: 1 }
  
  before_save { self.email = self.email.downcase }

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