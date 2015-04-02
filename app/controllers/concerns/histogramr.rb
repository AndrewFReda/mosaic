module Histogramr
  # TODO: Should this be put into Histogram class insted?
  extend ActiveSupport::Concern

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

  # Create a cache filled with pictures matching given composition picture ids
  # Buckets sorted based on dominant hue from the Histograms
  def create_histogram_cache_from_ids(comp_ids)
    cache = Hash.new { [] }

    comp_ids.each do |comp_id|
      comp_pic   = Picture.find(comp_id)
      hue        = comp_pic.histogram.dominant_hue
      img        = Image.read(comp_pic.image).first
      cache[hue] = cache[hue].push(img)
    end
    cache
  end

end