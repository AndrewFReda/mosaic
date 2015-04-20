class PicturesController < ApplicationController
  include Histogramr

  respond_to :json, only: [:index, :create]

  def index
    # TODO: Should this just be 'current_user' instead?
    @user = User.find params[:user_id]
    respond_with @user.pictures
  end

  def create
    #@user         = User.find(params[:user_id])
    @picture      = Picture.new picture_params
    @picture.user = current_user
    @picture.url  = "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/#{@picture.user.email}/#{@picture.type}/#{@picture.name}"
    @s3_upload    = S3Upload.new({ picture: @picture })

    if @picture.save
      render json: {
        key:          "#{@picture.user.email}/#{@picture.type}/#{@picture.name}",
        policy:       @s3_upload.policy_document(), 
        signature:    @s3_upload.signature(),
        content_type: @picture.getContentType(),
        access_key:   ENV['S3_ACCESS_KEY']
      }
    else
      respond_with @picture, status: 500
    end
  end

  private

    def picture_params
      params.require(:picture).permit(:name, :type, :user_id)
    end

  ################################### Not implemented ###################################

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

    respond_with @user.mosaics.last
  end

  def delete_mosaic
    @user = current_user

    if params[:mosaic] and params[:mosaic][:id]
      @picture = Picture.find(params[:mosaic][:id])
      @picture.destroy
      # TODO: Delete off of S3 as well
      # success
      respond_with status: 204, nothing: true
    elsif @user.mosaics.last
      @user.mosaics.last.delete
      # TODO: Delete off of S3 as well
      # success
      respond_with @user, status: 204
    else
      # failure
      respond_with @user, status: 401
    end
  end

  def clean_ids(ids)
    # TODO: Fix this hack work around for "" being sent along with ids
    # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
    ids.delete_if { |comp_id| comp_id.empty? }
  end

end