class Histogram < ActiveRecord::Base
  belongs_to :picture

  def set_hue_from_image(img)
    num_colors = 8

    img   = img.quantize(num_colors)
    hist  = img.color_histogram
    simplified_hist = Hash.new{ 0 }

    # Sort 8-color occurences in histogram into 18 buckets
    hist.each do |h|
      hsla = h.first.to_hsla
      pos  = (hsla[0].to_i / 20) % 18
      simplified_hist[pos] += h.last
    end

    # Sort by number of times pixel appeared from greatest to least
    sorted = simplified_hist.sort_by { |pos, v| v }.reverse
    self.dominant_hue = sorted.first.first
    self
  end

end
