class UsersController < ApplicationController
  include Histogramr

  def new
    @user = User.new
  end

  def show
    @user = User.find params[:id]
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.set_session_id(session)
      redirect_to new_picture_path
    else
      if @user.errors[:email].empty?
        # password and confirmation do not match
        redirect_to new_user_path, status: 401
      else
        # user with this email already exists
        redirect_to new_user_path, status: 400
      end
    end
  end

  def logout
    @user = current_user
    @user.unset_session_id(session)
    redirect_to login_user_path
  end

  def new_login
    @user = User.new
  end

  def login
    @user = User.find_by(email: user_params[:email])
    if @user and @user.authenticate(user_params[:password])
      @user.set_session_id(session)
      # success
      render '/pictures/new'
    else
      @user = User.new
      # failure
      render 'new_login', status: 401
    end
  end

  def change_password
    @user  = current_user
    status = nil

    if user_params[:password] == user_params[:password_confirmation]
      if @user and @user.authenticate(user_params[:password])
        if @user.update(password: params[:user][:new_password])
          # success
          status = 200
        else
          # failure to update password
          status = 500
        end
      else
        # password is incorrect
        status = 401
      end
    else
       # password and confirmation do not match
      status = 401
    end

    render new_picture_path, status: status
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

    render 'show'
  end

  def upload_pictures
    @user = current_user
    
    @user.add_composition_pictures_from_tempfiles params[:user][:compositions]
    @user.add_base_pictures_from_tempfiles params[:user][:bases]

    render 'pictures/new'
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :password_digest, :composition_picture_ids, :base_picture_ids, :mosaic_ids)
    end

    # TODO: Fix this hack work around for "" being sent along with ids
    # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
    def clean_ids(ids)
      ids.delete_if { |id| id.empty? }
    end
end