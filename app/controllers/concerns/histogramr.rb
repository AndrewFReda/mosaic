module Histogramr
  # TODO: Should this be put into Histogram class insted?
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

    sorted = sort_by_population(simplified_hist)
    Histogram.new(dominant_hue: sorted.first.first)
  end


  # Sort by number of times pixel appeared from greatest to least
  def sort_by_population(histogram)
    histogram.sort_by { |pos, v| v }.reverse
  end

  # Return a Picture with a Histogram that matches the given base grid image's Histogram
  # Picture is randomly selected from all matching pictures
  # Error on failure to find image
  def find_picture_by_hist(base_hist, comp_pics, cache)
    index = find_index_by_hist(base_hist, comp_pics)

    if cache[index].nil?
      cache[index] = comp_pics[index]
    else
      cache[index]
    end
  end

  # Return an index for a Histogram that matches the given base grid image's Histogram
  # Index randomly selected from all matching indexes
  # Error on failure to find image
  def find_index_by_hist(base_hist, comp_pics)
    matches = []
    comp_pics.each_with_index do |comp_pic, i|
      # Determines if they share the same dominant color bucket
      comp_hist = comp_pic.histogram
      if base_hist.dominant_hue == comp_hist.dominant_hue
        matches << i
      end
    end

    if matches.empty?
      raise 'Could not find sufficient matching composition images.'
    else
      matches.sample
    end
  end


  # Fill given cache with pictures from given comp_pics
  # Buckets sorted based on dominant hue from the Histogram
  def fill_cache_by_hist(cache, comp_pics)
    
    comp_pics.each do |comp_pic|
      hue = comp_pic.histogram.dominant_hue
      cache[hue] = cache[hue].push(comp_pic)
    end
    cache
  end

end