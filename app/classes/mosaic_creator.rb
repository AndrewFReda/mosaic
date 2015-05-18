class MosaicCreator

  def initialize(attrs)
    if attrs
      base_picture         = attrs[:base_picture]
      composition_pictures = attrs[:composition_pictures]
      @base_image          = MiniMagick::Image.open(URI::encode(base_picture.url))
      @cache               = PicturesCache.new({ pictures: composition_pictures })
      set_aspect_ratio()
      create()
    end
  end

  def get_image
    @image
  end

  private
    # Determine aspect ratio of this Mosaic based on its Base Picture
    def set_aspect_ratio
      @columns   = 25
      @rows      = 25
      base_image_columns = @base_image["%w"].to_i
      base_image_rows    = @base_image["%h"].to_i

      if base_image_columns > base_image_rows
        @columns *= (base_image_columns / base_image_rows.to_f)
        @columns = @columns.round
      else
        @rows *= (base_image_rows / base_image_columns.to_f)
        @rows = @rows.round
      end
    end

    def create
      # Divide base image into a grid that is basis mosaic grid
      # Determine *EXACT* height/width of the individual base image cells 
      base_cell_width  = @base_image["%w"].to_f / @columns
      base_cell_height = @base_image["%h"].to_f / @rows
      dimensions = "#{base_cell_width}x#{base_cell_height}"
      mosaic = MiniMagick::Tool::Convert.new

      # iterate through the grid that represents the final mosaic
      @rows.times do |r|
        row = MiniMagick::Tool::Convert.new

        @columns.times do |c|
          image = MiniMagick::Image.open(@base_image.path)
          # MiniMagick#crop
          image.crop "#{dimensions}+#{(base_cell_width * c)}+#{(base_cell_height * r)}"
          # Find image from cache with hue matching given image
          matching = @cache.find_matching_image image
          row << matching.path
          image.destroy!
        end

        row_path = "tmp/row-#{r}.png"
        row << '+append' << row_path
        row.call

        mosaic << row_path
      end

      mosaic << '-append' << 'tmp/mosaic.png'
      mosaic.call
      @image = MiniMagick::Image.new('tmp/mosaic.png')
    end
end