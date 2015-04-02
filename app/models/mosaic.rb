class Mosaic < ActiveRecord::Base
#  has_one :mosaic, class_name: 'Picture', dependent: :destroy


  def set_grid_from_image(base_img)
    # Determine ratio of mosaic image based on aspect of base image
    if base_img.columns > base_img.rows
      self.grid_columns = 120 * (base_img.columns / base_img.rows)
      self.grid_rows    = 120
    else
      self.grid_columns = 120
      self.grid_rows    = 120 * (base_img.rows / base_img.columns)
    end
  end

end
