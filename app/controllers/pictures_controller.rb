class PicturesController < ApplicationController
  include Histogramr

  def new
    @picture = Picture.new
    @user = current_user
    render json: @user
  end

  def create
    @user = current_user
    
    @user.add_composition_pictures_from_tempfiles params[:user][:compositions]
    @user.add_base_pictures_from_tempfiles params[:user][:bases]

    render json: @user
  end

  def create_mosaic
    @user = current_user

    # Retrieve image that will be used as basis for mosaic
    @picture = Picture.find(params[:user][:base_picture_ids])
    base_img = Image.read(@picture.image).first

    # Create cache and fill buckets with composition pictures matching given ids
    #  Cache keys are histogram hues
    comp_ids = clean_ids(params[:user][:composition_picture_ids])
    cache    = create_histogram_cache_from_ids(comp_ids)

    @mosaic    = Mosaic.new
    mosaic_img = @mosaic.create_from_img_and_cache(base_img, cache)
    @user.add_mosaic_from_IM_image(mosaic_img)

    render json: @user.mosaics.last
  end

  def delete_mosaic
    @user = current_user

    if params[:mosaic] and params[:mosaic][:id]
      @picture = Picture.find(params[:mosaic][:id])
      @picture.destroy
      # TODO: Delete off of S3 as well
      # success
      render nothing: true, status: 204
    elsif @user.mosaics.last
      @user.mosaics.last.delete
      # TODO: Delete off of S3 as well
      # success
      render nothing: true, status: 204
    else
      # failure
      render json: @user, status: 401
    end
  end

  private
    def picture_params
      params.require(:picture).permit(:compositions, :bases)
    end

    def clean_ids(ids)
      # TODO: Fix this hack work around for "" being sent along with ids
      # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
      ids.delete_if { |comp_id| comp_id.empty? }
    end

end