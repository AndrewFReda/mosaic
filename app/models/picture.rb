class Picture < ActiveRecord::Base
  has_one :histogram, dependent: :destroy

end
