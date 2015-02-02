class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  validates :email, presence: true,
                    # TODO: Email validation is saying everything fails. Figure out why.
                    #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
 
  validates :password, length: { minimum: 1 }

  has_many :composition_pictures, class_name: 'Picture', foreign_key: 'composition_id', dependent: :destroy
  has_many :base_pictures, class_name: 'Picture', foreign_key: 'base_id', dependent: :destroy
  has_many :mosaics, class_name: 'Picture', foreign_key: 'mosaic_id', dependent: :destroy

end
