class Histogram < ActiveRecord::Base
  belongs_to :picture

  def set_hue(attrs)
    if attrs[:image]
      self.dominant_hue = get_hue_from_image(attrs[:image])
    elsif attrs[:dominant_hue]
      self.dominant_hue = attrs[:dominant_hue]
    end
  end

  def get_hue_from_image(image)
    num_colors      = 1
    quantized_image = image.quantize(num_colors)
    histogram       = quantized_image.color_histogram
    # { Pixel => Occurences}
    dominant_pixel  = histogram.first.first
    hue             = dominant_pixel.to_hsla[0].to_i
    # Divide 360 possible degrees of hue into 18 buckets (360/20=18)
    hue_bucket      = (hue / 20) % 18
  end
end
