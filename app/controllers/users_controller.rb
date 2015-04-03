class UsersController < ApplicationController
  include Histogramr
  include Uploadr
  before_action :bypass_auth, only: [:new, :login]

  def new
    @user = User.new
  end

  def show
    @user = User.find params[:id]
  end

  def create
    @user = User.new user_params

    if @user.save
      session[:user_id] = @user.id
      redirect_to new_picture_path
    else
      if @user.errors[:email].empty?
        flash.now[:alert] = 'Password and confirmation do not match.'
        redirect_to new_user_path, status: 401
      else
        flash.now[:alert] = 'User with this email already exists.'
        redirect_to new_user_path, status: 400
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_user_path
  end

  def new_login
    @user = User.new
  end

  # TODO make both either redirect or render
  def login
    @user = User.find_by(email: user_params[:email])
    if @user and @user.authenticate(user_params[:password])
      session[:user_id] = @user.id
      redirect_to(new_picture_path, notice: "Welcome back, #{@user.email}")
    else
      @user = User.new
      flash.now[:alert] = 'Invalid email or password.'
      render 'new_login', status: 401
    end
  end

  def change_password
    @user  = current_user
    status = nil

    if user_params[:password] == user_params[:password_confirmation]
      if @user and @user.authenticate(user_params[:password])
        if @user.update(password: params[:user][:new_password])
          flash.now[:notice] = 'Successfully updated password.'
          status = 200
        else
          flash.now[:alert] = 'Failed to update password.'
          status = 500
        end
      else
        flash.now[:alert] = 'Password is incorrect.'
        status = 401
      end
    else
      flash.now[:alert] = 'Password and confirmation do not match.'
      status = 401
    end

    render new_picture_path, status: status
  end


  # TODO: Fix problem where all IDs to be deleted are sent as the :composition_picture_ids in addition
  #       to their other types
  def delete_pictures
    @user = current_user
    # TODO: Fix this hack work around for "" being sent along with ids
    # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
    dirty_ids = params[:user][:composition_picture_ids].concat(params[:user][:base_picture_ids]).concat(params[:user][:mosaic_ids])
    ids       = dirty_ids.delete_if { |id| id.empty? }

    @user.destroy_pictures_by_ids(ids)

    flash.now[:notice] = 'Successfully deleted pictures.'
    render 'show'
  end

  def upload_pictures
    @user = current_user
    
    upload_composition
    upload_base

    flash.now[:notice] = 'Images successfully uploaded.'
    render 'pictures/new'
  end

  def bypass_auth
    if current_user
      redirect_to new_picture_path
    else
      # Do nothing.
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :password_digest, :composition_picture_ids, :base_picture_ids, :mosaic_ids)
    end
end