class Histogram < ActiveRecord::Base
  belongs_to :picture

  def set_hue(attrs)
    if attrs[:image]
      self.dominant_hue = determine_image_hue(attrs[:image])
    elsif attrs[:dominant_hue]
      self.dominant_hue = attrs[:dominant_hue]
    end
  end

  private
    def determine_image_hue(image)
      # Reduce colors
      num_colors = 1
      image.colors(num_colors)
      # Find hue of dominant color (expressed as a decimal)
      hue = image["%[fx:hue]"].to_f * 360
        # Determine hue bucket
        (hue / 20).to_i % 18
  end
end
