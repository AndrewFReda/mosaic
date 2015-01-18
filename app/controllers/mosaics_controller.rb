class MosaicsController < ApplicationController
  include Histogramr

  def new
    @mosaic = Mosaic.new
    @user = current_user
  end

  def show
    binding.pry
    @mosaic = Mosaic
  end

  def create
    @user    = current_user
    binding.pry
    #base_img = Image.read(@user.base_pictures[(@user.base_pictures.size - 1)].image).first
    # At this point we have a histogram version of each of our composition images
    # Now we need to analyze our base image, breaking it up into a grid

    # Each grid piece will be anlayzed to determine main color content
    # Using the list of histograms, we can find the best fitting pictures for each square

    # Grid is an Array of Arrays where outer/inner arrays represent X/Y respectively
    # Array[0][0] represents upper left corner
    # For now starting out will be 8 coulmns with 10 rows
    rows    = 80  
    columns = 60
    
    # break base_img into grid and set up mosiac img
    grid_img_width  = base_img.columns / columns
    grid_img_height = base_img.rows / rows
    grid_imgs = ImageList.new
    page  = Magick::Rectangle.new(0,0,0,0)
    cache = Hash.new

    columns.times do |c|
      rows.times do |r|
        # X and Y grid offset
        page.x = c * grid_img_width
        page.y = r * grid_img_height

        # crop to grid cell image and create corresponding histogram
        cropped_img  = base_img.crop(page.x, page.y, grid_img_width, grid_img_height, true)
        cropped_hist = to_histogram(cropped_img)
        # find composition image with histgram matching this grid cell image's histogram
        img = find_img_by_hist(@user.composition_pictures, cache, cropped_hist)
        # resize image, insert and set page offsets
        scale = 5
        grid_imgs << img.scale((grid_img_width * scale), (grid_img_height * scale))
        page.x *= scale
        page.y *= scale
        grid_imgs.page = page
      end
    end 

    name     = "mosaichank3.jpg"
    path     = "/Users/andrewfreda/dev/rails/mosaics/app/assets/images/#{name}"
    name     = "#{DateTime.now.to_s}-#{name}"
    mosaic   = grid_imgs.mosaic
    mosaic.write(path)
    image    = File.open(path)
    @picture = Picture.new(name: name, image: image, mosaic_id: @user.id)
    if @picture.save
      @user.mosaics << @picture
    else
      @picture.destroy
      raise "Problems saving mosaic image."
    end
    image.close
  end

  def upload_comp
    @mosaic = Mosaic.new
    @user   = current_user
    # retrieve names of composition images from specified path
    img_names = Dir.entries("/Users/andrewfreda/dev/rails/mosaics/app/assets/images/test_images")
    # remove '.' and '..' and any other file starting with '.'
    img_names.delete_if { |x| x.start_with?('.') }

    img_names.each_with_index do |name, i|
      # create image and histogram
      path = "/Users/andrewfreda/dev/rails/mosaics/app/assets/images/test_images/#{name}"
      file = File.open(path)
      name = "#{DateTime.now.to_s}-#{name}"
      img  = Image.read(file).first
      @picture = Picture.new(name: name, histogram: to_histogram(img), image: file, composition_id: @user.id)
      #@picture.image.options[:path] = "/#{@user.email}/composition-pictures/#{name}"

      if @picture.save
        @user.composition_pictures << @picture
      else
        binding.pry
        @picture.destroy
        raise "Problems uploading one of the pictures."
      end
      # Check url after the picture is saved to see if it saved on S3 without error
      # If url reset to default, image overwrote an existing one on S3
      #if @picture.image.url != URI::encode("https://s3.amazonaws.com/afr-mosaic/#{@user.email}/composition-pictures/#{name}") and
      #    @picture.image.url != @user.composition_pictures[(@user.composition_pictures.size - 1)].image.url
      #end
      file.close
    end

    flash[:notice] = 'Composition images uploaded.'
    render 'new'
  end

  def upload_base
    # retrieve base image and create the mosaic from it
    @user = current_user
    name  = 'hank3.png'
    file  = File.open("/Users/andrewfreda/dev/rails/mosaics/app/assets/images/#{name}")
    name  = "#{DateTime.now.to_s}-#{name}"
    @picture = Picture.new(name: name, image: file, base_id: @user.id)

    if @picture.save
      @user.base_pictures << @picture
      flash[:notice] = 'Base image uploaded.'
      render 'new'
    else
      raise 'Problems uploading the base picture.'
    end
  end


  private
    def mosaic_params
    end

end