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

  # Determine aspect ratio of this Mosaic based on its Base Picture
  def set_aspect_ratio
    @columns   = 25
    @rows      = 25
    base_image_columns = @base_image["%w"].to_i
    base_image_rows    = @base_image["%h"].to_i
    binding.pry
    if base_image_columns > base_image_rows
      @columns *= (base_image_columns / base_image_rows)
    else
      @rows    *= (base_image_rows / base_image_columns)
    end

    temp_file = Tempfile.new(['render_composite_image', '.jpg'])
    @image = MiniMagick::Image.new(temp_file.path, temp_file)
    # Have to run this command to actually create the files
    @image.run_command(:convert, "-size", "#{@columns * 60}x#{@rows * 60}", "xc:white", @image.path)
  end

  def create
    # Divide base image into a grid that is basis mosaic grid
    # Determine *EXACT* height/width of the individual base image cells 
    base_cell_width  = @base_image["%w"].to_i / @columns.to_f
    base_cell_height = @base_image["%h"].to_i / @rows.to_f
    binding.pry

    # iterate through the grid that represents the final mosaic
    @columns.times do |c|
      @rows.times do |r|
        image      = MiniMagick::Image.open(@base_image.path)
        dimensions = "#{base_cell_width}x#{base_cell_height}"
        # Need to round else it will always round down
        offsets    = "+#{(base_cell_width * c).round}+#{(base_cell_height * r).round}"

        # MiniMagick#crop
        image.crop "#{dimensions}#{offsets}" # +repage"
        # Find image from cache with hue matching given image
        image = @cache.find_matching_image image

        @image = @image.composite(image) do |comp|
          comp.gravity "NorthWest"
          # TODO: Do scaling better  
          comp.geometry "+#{c * 60}+#{r * 60}"
        end
      end
    end
  end
end