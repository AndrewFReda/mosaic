class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates_length_of :password, minimum: 1

  has_many :composition_pictures, class_name: 'Picture', foreign_key: 'composition_id', dependent: :destroy
  has_many :base_pictures, class_name: 'Picture', foreign_key: 'base_id', dependent: :destroy
  has_many :mosaics, class_name: 'Picture', foreign_key: 'mosaic_id', dependent: :destroy

end
