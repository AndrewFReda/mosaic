class Mosaic
  include ActiveModel::Model

  attr_accessor :image, :base_picture, :composition_pictures, :cache, :columns, :rows

  def initialize(attrs)
    super
    if attrs
      @base_picture = attrs[:base_picture]
      @composition_pictures = attrs[:composition_pictures]
      set_composition_cache()
      set_aspect_ratio()
    end
  end

  # Create a cache filled with pictures matching composition
  # Buckets sorted based on dominant hue from the Histograms
  def set_composition_cache(scale = [60, 60])
    @cache = Hash.new { [] }

    @composition_pictures.each do |picture|
      hue         = picture.get_dominant_hue()
      image       = download_IMagick_image(picture.get_url())
      scaled      = image.scale(scale.first, scale.last)
      @cache[hue] = @cache[hue].push(scaled)
    end
  end

  # Determine aspect ratio of this Mosaic based on its Base Picture
  def set_aspect_ratio
    base_image = download_IMagick_image(@base_picture.get_url())
    @columns   = 80
    @rows      = 80

    if base_image.columns > base_image.rows
      @columns *= (base_image.columns / base_image.rows)
    else
      @rows *= (base_image.rows / base_image.columns)
    end

    @image = Image.new(@columns * @cache[0][0].columns, @rows * @cache[0][0].rows)
  end

  def create
    base_image = download_IMagick_image(@base_picture.get_url())
    histogram  = Histogram.new

    # Divide base image into a grid that is basis mosaic grid
    # Determine *EXACT* height/width of the individual base image cells 
    base_image_cell_width  = base_image.columns / @columns.to_f
    base_image_cell_height = base_image.rows / @rows.to_f

    # iterate through the grid that represents the final mosaic
    @columns.times do |c|
      @rows.times do |r|
        # Crop: starting x coord, starting y coord, x length, y length, discard non-cropped
        cropped = base_image.crop(base_image_cell_width * c, base_image_cell_height * r, 
                                   base_image_cell_width, base_image_cell_height, true)
        
        # Determine hue of cropped picture
        histogram.set_hue image: cropped
        # Find image with matching hue from cache
        image = @cache[histogram.dominant_hue].sample

        # Use .composite in place of .mosaic as the later seems to be broken
        @image.composite!(image, image.columns * c, image.rows * r, OverCompositeOp)
      end
    end
  end

  private
    # TODO: catch error if URI can't parse
    def download_IMagick_image(url)
      # Download file and open in File object
      file  = File.open(open(URI::encode(url)))
      image = Image.read(file).first
      file.close
      return image
    end
end