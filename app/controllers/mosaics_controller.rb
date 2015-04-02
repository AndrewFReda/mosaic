class MosaicsController < ApplicationController
  include Histogramr
  include Uploadr

  before_action :sanitize_composition_ids, only: :create

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
      flash.now[:notice] = 'Mosaic successfully deleted.'
    elsif @user.mosaics.last
      @user.mosaics.last.delete
      # TODO: Delete off of S3 as well
      flash.now[:notice] = 'Mosaic successfully deleted.'
    else
      flash.now[:alert] = 'Problem occured while deleting the mosaic.'
      status            = 401 
    end

    status ||= 200
    redirect_to new_mosaic_path, status: status
  end

  def create
    # Retrieve image that will be used as basis for mosaic
    @picture = Picture.find(params[:user][:base_picture_ids])
    base_img = Image.read(@picture.image).first

    # Create cache and fill buckets with composition pictures matching given ids
    #  Cache keys are histogram hues
    comp_ids = params[:user][:composition_picture_ids]
    cache    = create_histogram_cache_from_ids(comp_ids)

    @mosaic    = Mosaic.create
    mosaic_img = @mosaic.create_from_img_and_cache(base_img, cache)
    mosaic_id  = upload_mosaic(mosaic_img)

    redirect_to mosaic_path(id: mosaic_id)
  end

  def upload
    @mosaic = Mosaic.new
    @user   = current_user
    
    upload_composition
    upload_base

    flash.now[:notice] = 'Images successfully uploaded.'
    render 'new'
  end

  private
    def mosaic_params
      params.require(:mosaic).permit(:compositions, :bases)
    end

    def sanitize_composition_ids
      # TODO: Fix this hack work around for "" being sent along with ids
      # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
      params[:user][:composition_picture_ids].delete_if { |comp_id| comp_id.empty? }
    end

end