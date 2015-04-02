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


  def create_from_img_and_cache(base_img, cache)

    set_grid_from_image(base_img)
    final_img = Image.new(base_img.columns, base_img.rows)

    # Divide given base image into a grid and determine the dominant color of each cell
    # 
    # Determine *EXACT* height/width of the individual grid cells 
    base_grid_cell_width  = base_img.columns / self.grid_columns.to_f
    base_grid_cell_height = base_img.rows / self.grid_rows.to_f

    # iterate through the grid that will represent the mosaic
    self.grid_columns.times do |c|
      self.grid_rows.times do |r|
        # X and Y current base_img offsets
        current_grid_x = c * base_grid_cell_width
        current_grid_y = r * base_grid_cell_height

        # Crop to grid cell image and create corresponding histogram
        # Crop: starting x pixel coord, starting y pixel coord, x pixel length, y pixel length, discard non-cropped
        cropped_img = base_img.crop(current_grid_x, current_grid_y, 
                                      base_grid_cell_width, base_grid_cell_height, 
                                        true)
        hist = Histogram.new
        hist.set_hue_from_image(cropped_img)
        hue = hist.dominant_hue

        # Find composition image of matching dominant hue with the cropped image, 
        #  chosen at random from the cache's matching hue sub-array
        img = cache[hue].sample
        final_img.composite!(img, current_grid_x, current_grid_y, OverCompositeOp)
      end
    end

    final_img
  end

end
