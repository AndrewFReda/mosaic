class MosaicsController < ApplicationController
  include Histogramr

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
    rows    = 8
    columns = 10
    comp_img_width  = base_img.columns / columns
    comp_img_height = base_img.rows / rows
    grid_imgs = ImageList.new
    page = Magick::Rectangle.new(0,0,0,0)

    columns.times do |c|
      rows.times do |r|
      
        page.x = c * comp_img_width
        page.y = r * comp_img_height

        cropped_img  = base_img.crop(page.x, page.y, comp_img_width, comp_img_height, true)
        cropped_hist = to_histogram(cropped_img)
        cropped_hist = sort_by_population(cropped_hist)
        index        = find_img_index(comp_hists, cropped_hist)
        grid_imgs << comp_imgs[index].dup.scale(comp_img_width, comp_img_height)
        grid_imgs.page = page
      end
    end 

    mosaic = grid_imgs.mosaic
    mosaic.write("mosaic.jpg")

  end


  private
    def mosaic_params
      params.require(:mosaic).permit(:base_img, :comp_imgs_dir, :max_comp_imgs)
    end

end