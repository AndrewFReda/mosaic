# Lazily instantiated cache populated with Pictures and returns ImageMagick Images.
#  Cache sorts Pictures into buckets based on dominant hue in Picture's Image.
class PicturesCache

  def initialize(attrs)
    if attrs
      @pictures  = attrs[:pictures]
      @histogram = Histogram.new
      @cache     = Hash.new { [] }
      populate()
    end
  end

  # Fill this cache with Pictures sorted into buckets by 
  #  its Histogram's dominant hue
  def populate
    @pictures.each do |picture|
      hue         = picture.get_dominant_hue()
      @cache[hue] = @cache[hue].push(picture)
    end
  end

  # Lazily converts Pictures into ImageMagick Images as they are used:
  #  If random matching element is a Picture, download the ImageMagick version,
  #   scale it down and insert it back into the cache
  def find_matching_image(image)
    hue    = @histogram.set_hue image: image
    bucket = @cache[hue]
    index  = rand(bucket.size) # 0 <= index < bucket.size
    random = bucket[index]

    if random.class.to_s == 'Picture'
      image  = MiniMagick::Image.open(URI::encode(random.url))
      # TODO: Figure out better way to scale
      image.scale "60x60!"
      bucket[index] = random = image
      @cache[hue]   = bucket
    end

    random
  end
end