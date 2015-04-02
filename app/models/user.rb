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

  def destroy_pictures_by_ids(ids)
    ids and ids.each do |id|
      @picture = Picture.find(id)
      # TODO: Check if user owns picture
      if not @picture.destroy
        raise 'Problem deleting a picture.'
      end
    end
  end

end
