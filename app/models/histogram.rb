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
      #sat = image["%[fx:saturation]"].to_f * 100
      lit = image["%[fx:lightness]"].to_f * 100
      #lum = image["%[fx:luma]"].to_f * 100
      # Determine if saturated out
      #if sat <= 5
      #  return "grey"
      #elsif lit >= 95
      if lit >= 95
        18 # represents white
      elsif lit <= 15
        19 # represents black
      else      
        # Determine hue bucket
        (hue / 20).round % 18
      end
  end
end
