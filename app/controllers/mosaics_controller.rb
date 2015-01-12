class MosaicsController < ApplicationController

  def new
    @mosaic = Mosaic.new
  end

  def show
    binding.pry
  end

  def create
    @mosaic   = Mosaic.new mosaic_params
    # retrieve base image
    base_img  = Image.read("app/assets/images/me.jpg").first # (@mosaic.base_img)
    # retrieve composition images' names
    img_names = Dir.entries("/Users/andrewfreda/dev/rails/mosaics/app/assets/images/test") #("#{@mosaic.comp_imgs_dir}")
    img_names.delete_if { |x| x.start_with?('.') }
    comp_imgs = ImageList.new
    comp_hists = Array.new

    @mosaic.max_comp_imgs.times do |i|
      if i < img_names.size
        path = "/Users/andrewfreda/dev/rails/mosaics/app/assets/images/test/#{img_names[i]}" # "#{(@mosaic.comp_imgs_dir)}/#{img_names[i])}"
        comp_imgs.read(path)
        comp_hists[i] = to_histogram(comp_imgs[i])
      else
        break
      end
    end

    # At this point we have a histogram version of each of our composition images
    # Now we need to analyze our base image, breaking it up into a grid

    # Each grid piece will be anlayzed to determine main color content
    # Using the list of histograms, we can find the best fitting pictures for each square

    # Grid is an Array of Arrays where outer/inner arrays represent X/Y respectively
    # Array[0][0] represents upper left corner
    # For now starting out will be 8 coulmns with 10 rows
    rows    = 10
    columns = 8
    grid    = Array.new(columns, Array.new(rows))
    comp_img_width  = base_img.columns / columns
    comp_img_height = base_img.rows / rows

    columns.times do |c|

      rows.times do |r|
      
        x = c * comp_img_width
        y = r * comp_img_height

        cropped_img  = base_img.crop(x, y, comp_img_width, comp_img_height, true)
        cropped_hist = to_histogram(cropped_img)
        cropped_hist = sort_by_population(cropped_hist)
        grid[c][r]   = comp_img[index]
        index        = find_img_index(comp_hists, cropped_hist)
      end
    end 

    
  end

  ##### HELPER METHODS
  def to_histogram(img)
    num_colors  = 256
    hist_height = 250

    img   = img.quantize(num_colors)
    hist  = img.color_histogram
    scale = hist_height / (hist.values.max*1.025)   # put 2.5% air at the top
    # Transform histogram here, reducing # buckets and sorting
    hist  = reduce_histogram(hist)
    hist  = sort_by_population(hist)
  end

  # Reduce the incoming histogram to have 18 buckets representing (fixed) color ranges
  # These colors are displayed as the average color from that range with a corresponding total number of occurences
  def reduce_histogram(histogram)
    simplified_hist = Hash.new{ [] }

    # Fill 18 buckets with pixels from 256 colors
    histogram.each do |h|

      hsla = h.first.to_hsla
      pos  = ((hsla[0] + 10).to_i / 20) % 18
      simplified_hist[pos] = simplified_hist[pos].push(h)
    end

    # Find average pixel representing each bucket
    simplified_hist.each do |pos,arr|

      avg_hsla = [0,0,0,0]
      total    = 0

      arr.each do |p,n|
        avg_hsla[0] += p.to_hsla[0]
        avg_hsla[1] += p.to_hsla[1]
        avg_hsla[2] += p.to_hsla[2]
        avg_hsla[3] += p.to_hsla[3]
        total       += n
      end

      avg_hsla.collect! { |n| (n / arr.size).round(1) }
      pixel = Magick::Pixel.from_hsla(avg_hsla[0], avg_hsla[1], avg_hsla[2], avg_hsla[3])
      # Output: {Pos => {Pixel => Total}, Pos => ...}
      simplified_hist[pos] = {pixel => total}
    end
    simplified_hist
  end

  # Sort according to hue from HSLa
  def sort_by_color(histogram)
    histogram.sort_by { |pos, v| v.keys.first.to_hsla[0] }
  end

  # Sort by number of times pixel appeared from greatest to least
  def sort_by_population(histogram)
    histogram.sort_by { |pos, v| v.values.first }.reverse
  end


  def find_img_index(comp_hists, base_hist)
    3.times do |color_pos|
      comp_hists.each_with_index do |comp_hist, i|

        # First [0] accesses highest occuring color
        # Second [0] accesses reduced color bucket number
        base_color = base_hist[0][0]
        comp_color = comp_hist[color_pos][0]
        if base_color == comp_color
          return i
        end
      end
    end

    # Raise an error if loop completed (i.e. found no match)
    # ** Consider setting flag to check after completion instead of just raising error
    binding.pry
    raise 'Could not find suitable images.'
  end




  private
    def mosaic_params
      params.require(:mosaic).permit(:base_img, :comp_imgs_dir, :max_comp_imgs)
    end

end