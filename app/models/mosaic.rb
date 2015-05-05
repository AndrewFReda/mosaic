class Mosaic
  include ActiveModel::Model

  attr_accessor :image, :base_picture, :composition_pictures, :cache, :columns, :rows, 

  def initialize(attrs)
    super
    if attrs
      @base_picture = attrs[:base_picture]
      @composition_pictures = attrs[:composition_pictures]
      set_cache()
      set_aspect_ratio()
    end
  end

  # Create a cache filled with pictures matching composition
  # Buckets sorted based on dominant hue from the Histograms
  def set_cache
    @cache = Hash.new { [] }

    @composition_pictures.each do |picture|
      hue         = picture.get_dominant_hue()
      file        = File.open(open(URI::encode(picture.url)))
      image       = Image.read(file).first
      @cache[hue] = @cache[hue].push(image)
    end
  end

  # Determine aspect ratio of this Mosaic based on its Base Picture
  def set_aspect_ratio
    file       = File.open(open(URI::encode(@base_picture.url)))
    base_image = Image.read(file).first
    @image     = Image.new(base_image.columns, base_image.rows)

    if base_image.columns > base_image.rows
      @columns = 60 * (base_image.columns / base_image.rows)
      @rows    = 60
    else
      @columns = 60
      @rows    = 60 * (base_image.rows / base_image.columns)
    end
  end

  def create
    file       = File.open(open(URI::encode(@base_picture.url)))
    base_image = Image.read(file).first

    # Divide base image into a grid that will map to mosaic grid
    # Determine *EXACT* height/width of the individual base image cells 
    base_image_column_width = base_image.columns / @columns.to_f
    base_image_row_height   = base_image.rows / @rows.to_f
    histogram = Histogram.new

    base_image_x = 0
    # iterate through the grid that will represent the mosaic
    @columns.times do |c|
      @rows.times do |r|
        # X and Y current base_img offsets
        base_image_x = c * base_image_column_width
        base_image_y = r * base_image_row_height

        # Crop to grid cell image and create corresponding histogram
        # Crop: starting x pixel coord, starting y pixel coord, x pixel length, y pixel length, discard non-cropped
        cropped_img = base_image.crop(base_image_x, base_image_y, 
                                      base_image_column_width, base_image_row_height, 
                                        true)
        hue = histogram.get_hue_from_image image

        # Find composition image of matching dominant hue with the cropped image, 
        #  chosen at random from the cache's matching hue sub-array
        img = @cache[hue].sample

        @image.composite!(img, base_image_x, base_image_y, OverCompositeOp)
      end
    end

    @image
  end

end
