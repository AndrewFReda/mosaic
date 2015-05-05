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
  def set_cache(scale = [200, 200])
    @cache = Hash.new { [] }

    @composition_pictures.each do |picture|
      hue         = picture.get_dominant_hue()
      file        = File.open(open(URI::encode(picture.get_url())))
      image       = Image.read(file).first
      image       = image.scale(scale.first, scale.last)
      @cache[hue] = @cache[hue].push(image)
    end
  end

  # Determine aspect ratio of this Mosaic based on its Base Picture
  def set_aspect_ratio
    file       = File.open(open(URI::encode(@base_picture.get_url())))
    base_image = Image.read(file).first

    if base_image.columns > base_image.rows
      @columns = 60 * (base_image.columns / base_image.rows)
      @rows    = 60
    else
      @columns = 60
      @rows    = 60 * (base_image.rows / base_image.columns)
    end
  end

  def create
    file       = File.open(open(URI::encode(@base_picture.get_url())))
    base_image = Image.read(file).first

    # Divide base image into a grid that will map to mosaic grid
    # Determine *EXACT* height/width of the individual base image cells 
    base_image_cell_width  = base_image.columns / @columns.to_f
    base_image_cell_height = base_image.rows / @rows.to_f

    histogram = Histogram.new
    @image    = Image.new(@columns * mosaic_cell_width, @rows * mosaic_cell_height)

    # iterate through the grid that will represent the mosaic
    @columns.times do |c|
      @rows.times do |r|
        # Crop area to be analyzed from base_image and determine its hue

        # Crop: starting x pixel coord, starting y pixel coord, x pixel length, y pixel length, discard non-cropped
        cropped_img = base_image.crop(base_image_cell_width * c, base_image_cell_height * r, 
                                        base_image_cell_width, base_image_cell_height, true)
        hue = histogram.get_hue_from_image cropped_img
        
        img = @cache[hue].sample
        # Use .composite in place of .mosaic as the later seems to be broken
        @image.composite!(img, mosaic_cell_height * c, mosaic_cell_width * r, OverCompositeOp)
      end
    end
  end

end
