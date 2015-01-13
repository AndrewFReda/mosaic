class MosaicsController < ApplicationController
  include Histogramr

  def new
    @mosaic = Mosaic.new
  end

  def show
    binding.pry
  end

  def create
    @mosaic = Mosaic.new mosaic_params
    # retrieve base image
    base_img = Image.read("app/assets/images/me.jpg").first # (@mosaic.base_img)
    # retrieve names of composition images from specified path
    img_names = Dir.entries("/Users/andrewfreda/dev/rails/mosaics/app/assets/images/test") #("#{@mosaic.comp_imgs_dir}")
    # remove '.' and '..' and any other file starting with '.'
    img_names.delete_if { |x| x.start_with?('.') }
    # prepare image list and histogram lists
    comp_imgs  = ImageList.new
    comp_hists = Array.new

    @mosaic.max_comp_imgs.times do |i|
      # break if cycled through every file in directory
      if i < img_names.size
        path = "/Users/andrewfreda/dev/rails/mosaics/app/assets/images/test/#{img_names[i]}" # "#{(@mosaic.comp_imgs_dir)}/#{img_names[i])}"
        # create image and histogram
        comp_imgs.read(path)
        comp_hists[i] = to_histogram(comp_imgs[i])
      else
        break
      end
    end

    draw_mosaic(base_img, comp_imgs, comp_hists)
  end

  ##### HELPER METHODS
  def draw_mosaic(base_img, comp_imgs, comp_hists)
    # At this point we have a histogram version of each of our composition images
    # Now we need to analyze our base image, breaking it up into a grid

    # Each grid piece will be anlayzed to determine main color content
    # Using the list of histograms, we can find the best fitting pictures for each square

    # Grid is an Array of Arrays where outer/inner arrays represent X/Y respectively
    # Array[0][0] represents upper left corner
    # For now starting out will be 8 coulmns with 10 rows
    rows    = 160
    columns = 120
    
    # break base_img into grid and set up mosiac img
    grid_img_width  = base_img.columns / columns
    grid_img_height = base_img.rows / rows
    grid_imgs = ImageList.new
    page = Magick::Rectangle.new(0,0,0,0)

    columns.times do |c|
      rows.times do |r|
        # X and Y grid offset
        page.x = c * grid_img_width
        page.y = r * grid_img_height

        # crop to grid cell image and create corresponding histogram
        cropped_img  = base_img.crop(page.x, page.y, grid_img_width, grid_img_height, true)
        cropped_hist = to_histogram(cropped_img)
        # find composition image with histgram matching this grid cell image's histogram
        img = find_img_by_hist(comp_imgs, comp_hists, cropped_hist)
        # resize image, insert and set page offsets
        scale = 5
        grid_imgs << img.scale((grid_img_width * scale), (grid_img_height * scale))
        page.x *= scale
        page.y *= scale
        grid_imgs.page = page
      end
    end 

    mosaic = grid_imgs.mosaic
    mosaic.write("mosaic3.jpg")
  end


  private
    def mosaic_params
      params.require(:mosaic).permit(:base_img, :comp_imgs_dir, :max_comp_imgs)
    end

end