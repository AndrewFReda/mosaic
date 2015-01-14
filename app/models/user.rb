class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates_length_of :password, minimum: 1

  has_many :uploaded_pictures, { class_name: 'Picture', dependent: :destroy }

end
