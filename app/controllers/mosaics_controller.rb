class MosaicsController < ApplicationController
  include Histogramr
  include Uploadr

  def new
    @mosaic = Mosaic.new
    @user   = current_user
  end

  def show
    @user    = current_user
    @picture = Picture.find(params[:id])
  end

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
    @user   = current_user

    # Retrieve image that will be used as basis for mosaic
    base_id  = params[:user][:base_picture_ids]
    @picture = Picture.find(base_id)
    base_img = Image.read(@picture.image).first
    comp_ids = params[:user][:composition_picture_ids]
    # TODO: Fix this hack work around for "" being sent along with ids
    # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
    comp_ids.delete_if { |comp_id| comp_id.empty? }
    comp_pics = Array.new
    comp_ids.each do |comp_id|
      @picture = Picture.find(comp_id)
      comp_pics << @picture
    end

    # Divide this base image into a grid and determine the dominant color of each cell
    # Determine ratio of mosaic image based on aspect of base image
    mosaic_rows    = 60
    mosaic_columns = 60
    if base_img.columns > base_img.rows
      mosaic_columns *= (base_img.columns / base_img.rows)
    else
      mosaic_rows *= (base_img.rows / base_img.columns)
    end
    
    # Determine height/width of the individual grid cells 
    base_grid_cell_width  = base_img.columns / mosaic_columns
    base_grid_cell_height = base_img.rows / mosaic_rows
    # Create cache for initial lookup and acache for the scaled composition images
    cache = Hash.new
    scaled = Hash.new
    # Scale is somewhat arbitrary right now, but it determines size of final mosaic
    scale = 1
    mosaic = Image.new(base_img.columns * scale, base_img.rows * scale)

    # iterate through the grid that will represent the mosaic
    mosaic_columns.times do |c|
      mosaic_rows.times do |r|
        # X and Y current base_img offsets
        current_grid_x = c * base_grid_cell_width
        current_grid_y = r * base_grid_cell_height

        # Crop to grid cell image and create corresponding histogram
        # Crop: starting x pixel coord, starting y pixel coord, x pixel length, y pixel length, discard non-cropped
        cropped_img  = base_img.crop(current_grid_x, current_grid_y, 
                                      base_grid_cell_width, base_grid_cell_height, true)
        cropped_hist = to_histogram(cropped_img)

        # Find composition image with matching histogram to base image's current cropped histogram
        @picture = find_picture_by_hist(cropped_hist, comp_pics, cache)
        
        if scaled[@picture.id].nil?
          img = Image.read(@picture.image).first
          scaled[@picture.id] = img.scale((base_grid_cell_width * scale), (base_grid_cell_height * scale))
        end

        mosaic.composite!(scaled[@picture.id], 
                          (current_grid_x * scale), 
                          (current_grid_y * scale), 
                          OverCompositeOp)
      end
    end 

    upload_mosaic(mosaic)

    # FIX:: NOT GOOD PRACTICE TO PASS WRONG ID
    redirect_to mosaic_path(id: @picture.id)
  end

  def upload
    @mosaic = Mosaic.new
    @user   = current_user
    
    upload_composition
    upload_base

    flash[:notice] = 'Images successfully uploaded.'
    render 'new'
  end

  private
    def mosaic_params
      params.require(:mosaic).permit(:compositions, :bases)
    end

end