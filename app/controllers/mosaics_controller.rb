class MosaicsController < ApplicationController
  include Histogramr

  def new
    @mosaic = Mosaic.new
    @user   = current_user
  end

  def show
    @mosaic = Mosaic
    @user   = current_user
  def delete
    @mosaic  = Mosaic.new
    @user    = current_user

    if params[:mosaic] and params[:mosaic][:id]
      @picture = Picture.find(params[:mosaic][:id])
      @picture.destroy
      # TODO: Delete off of S3 as well
      flash[:notice] = 'Mosaic successfully deleted.'
    elsif @user.mosaics.last.delete
      # TODO: Delete off of S3 as well
      flash[:notice] = 'Mosaic successfully deleted.'
    else
      raise 'Problem occured while deleting the mosaic.'
    end

    redirect_to new_mosaic_path
  end

  def create
    @mosaic = Mosaic.new
    @user    = current_user
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
    id = params[:user][:base_picture_ids].first
    @picture = Picture.find(id)
    base_img = Image.read(@picture.image).first
    
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

  def upload
    @mosaic = Mosaic.new
    @user   = current_user

    upload_comp
    upload_base

    flash[:notice] = 'Images successfully uploaded.'
    render 'new'
  end

  def upload_comp
    temps = params[:user][:compositions]

    # Check that temps is not nil before iterating
    temps and temps.each do |temp|
      file     = File.open(temp.tempfile)
      name     = "#{DateTime.now.to_s}-#{temp.original_filename}"
      img      = Image.read(file).first
      @picture = Picture.new(name: name, histogram: to_histogram(img), image: file, composition_id: @user.id)
      file.close

      if @picture.save
        @user.composition_pictures << @picture
      else
        @picture.destroy
        raise "Problems occured during upload of a picture."
      end
    end
  end

  def upload_base
    temps = params[:user][:bases]
    
    # Check that temps is not nil before iterating
    temps and temps.each do |temp|

      file     = File.open(temp.tempfile)
      name     = "#{DateTime.now.to_s}-#{temp.original_filename}"
      img      = Image.read(file).first
      @picture = Picture.new(name: name, image: file, composition_id: @user.id)
      file.close

      if @picture.save
        @user.base_pictures << @picture
      else
        @picture.destroy
        raise 'Problems uploading the base picture.'
      end
    end
  end

  private
    def mosaic_params
      params.require(:mosaic).permit(:compositions, :bases)
    end

end