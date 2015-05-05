class Histogram < ActiveRecord::Base
  belongs_to :picture

  def set_hue(attrs)
    if attrs[:image]
      self.dominant_hue = set_hue_from_image(attrs[:image])
    elsif attrs[:dominant_hue]
      self.dominant_hue = attrs[:dominant_hue]
    end
  end

  private
    # Set this Histogram's dominant hue from given ImageMagick image
    def set_hue_from_image(image)
      self.dominant_hue = get_hue_from_image(image)
    end

    def get_hue_from_image(image)
      num_colors      = 8
      image           = image.quantize(num_colors)
      quantized_hist  = image.color_histogram
      binding.pry
      simplified_hist = Hash.new{ 0 }

      # Sort 8-color histogram into 18 buckets
      quantized_hist.each do |color_hist|
        hsla = color_hist.first.to_hsla
        pos  = (hsla[0].to_i / 20) % 18
        simplified_hist[pos] += color_hist.last
      end

      # Sort by number of times pixel appeared from greatest to least
      sorted = simplified_hist.sort_by { |pos, v| v }.reverse
      sorted.first.first
    end
end
