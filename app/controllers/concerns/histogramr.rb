module Histogramr
  extend ActiveSupport::Concern

  def to_histogram(img)
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

    sort_by_population(simplified_hist)
  end


  # Sort by number of times pixel appeared from greatest to least
  def sort_by_population(histogram)
    histogram.sort_by { |pos, v| v }.reverse
  end


  # Return image corresponding to histogram that matches base img histogram
  # Error on failure
  # Image randomly selected from matching images
  def find_img_by_hist(comp_imgs, comp_hists, base_hist)
    index = find_index_by_hist(comp_hists, base_hist)

    # Raise an error if found no match
    if index.nil?
      raise 'Could not find sufficient matching composition images.'
    else
      return comp_imgs[index]
    end
  end

  # Return index corresponding to histogram that matches base img histogram on success
  # Return nil on failure
  # Index randomly selected from matching indexes
  def find_index_by_hist(comp_hists, base_hist)
    matches = []
    comp_hists.each_with_index do |comp_hist, i|
      # First [0] accesses highest occuring color
      # Second [0] accesses reduced color bucket number
      # Determines if they share the same dominant color bucket
      if base_hist[0][0] == comp_hist[0][0]
        matches << i
      end
    end

    return matches.sample
  end

end