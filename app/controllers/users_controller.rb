class UsersController < ApplicationController
  include Histogramr

  respond_to :json, only: [:create, :login]

  # Rails API back-end for Backbone front-end

  def create
    @user = User.new user_params

    if @user.save
      @user.set_session_id(session)
      respond_with @user
    else
      if @user.errors[:email].empty?
        # password and confirmation do not match
        respond_with @user, status: 401
      else
        # user with this email already exists
        respond_with @user, status: 400
      end
    end
  end

  def show
    @user = User.find params[:id]
    respond_with @user
  end

  def change_password
    @user  = current_user

    if user_params[:password] == user_params[:password_confirmation]
      if @user and @user.authenticate(user_params[:password])
        if @user.update(password: params[:user][:new_password])
          # success
          respond_with status: 200, nothing: true
        else
          # failure to update password
          respond_with status: 500, nothing: true
        end
      else
        # password is incorrect
        respond_with status: 401, nothing: true
      end
    else
       # password and confirmation do not match
      respond_with status: 401, nothing: true
    end
  end


  # TODO: Fix problem where all IDs to be deleted are sent as the :composition_picture_ids in addition
  #       to their other types
  def delete_pictures
    @user = current_user

    comp_ids   = clean_ids(params[:user][:composition_picture_ids])
    base_ids   = clean_ids(params[:user][:base_picture_ids])
    mosaic_ids = clean_ids(params[:user][:mosaic_ids])

    @user.delete_composition_pictures comp_ids
    @user.delete_base_pictures base_ids
    @user.delete_mosaics mosaic_ids

    respond_with @user
  end

  def upload_pictures
    @user = current_user
    
    @user.add_composition_pictures_from_tempfiles params[:user][:compositions]
    @user.add_base_pictures_from_tempfiles params[:user][:bases]

    respond_with @user
  end

  def mosaics
    @user = current_user
    respond_with @user.composition_pictures
  end

  private
    def user_params
      #params.require(:user).permit(:email, :password, :password_confirmation, :password_digest, :composition_picture_ids, :base_picture_ids, :mosaic_ids)
      params.permit(:email, :password, :password_confirmation, :password_digest, :composition_picture_ids, :base_picture_ids, :mosaic_ids)
    end

    # TODO: Fix this hack work around for "" being sent along with ids
    # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
    def clean_ids(ids)
      ids.delete_if { |id| id.empty? }
    end
end