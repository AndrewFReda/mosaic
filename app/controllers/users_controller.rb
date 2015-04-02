class UsersController < ApplicationController
  include Histogramr
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
      redirect_to new_mosaic_path
    else
      if @user.errors[:email].empty?
        flash[:alert] = 'Password and confirmation do not match.'
      else
        flash[:alert] = 'User with this email already exists.'
      end
      redirect_to new_user_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_user_path
  end

  def login
    @user = User.new
  end

  # TODO make both either redirect or render
  def login_user
    @user = User.find_by(email: user_params[:email])
    if @user and @user.authenticate(user_params[:password])
      session[:user_id] = @user.id
      redirect_to(new_mosaic_path, notice: "Welcome back, #{@user.email}")
    else
      @user = User.new
      flash[:alert] = 'Invalid email or password.'
      render login_user_path
    end
  end

  def change_password
    @user = current_user

    if user_params[:password] == user_params[:password_confirmation]
      if @user and @user.authenticate(user_params[:password])
        if @user.update(password: params[:user][:new_password])
          flash[:notice] = 'Successfully updated password.'
        else
          flash[:alert] = 'Failed to update password.'
        end
      else
        flash[:alert] = 'Password is incorrect.'
      end
    else
      flash[:alert] = 'Password and confirmation do not match.'
    end

    render new_mosaic_path
  end

  def delete_pictures
    @user = current_user
    # TODO: Fix this hack work around for "" being sent along with ids
    # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
    dirty_ids = params[:user][:composition_picture_ids].concat(params[:user][:base_picture_ids]).concat(params[:user][:mosaic_ids])
    ids       = dirty_ids.delete_if { |id| id.empty? }

    @user.destroy_pictures_by_ids(ids)

    flash[:notice] = 'Successfully deleted pictures.'
    render 'show'
  end

  def bypass_auth
    if current_user
      redirect_to new_mosaic_path
    else
      # Do nothing.
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :password_digest)
    end
end