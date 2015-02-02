class UsersController < ApplicationController
  include Histogramr
  before_action :check_auth, only: [:new, :login]

  def index
    @users = User.all
  end

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

  def destroy
    session[:user_id] = nil
    redirect_to login_user_path
  end

  def login
    @user = User.new
  end

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

    destroy_all_by_ids(params[:user][:composition_picture_ids])
    destroy_all_by_ids(params[:user][:base_picture_ids])
    destroy_all_by_ids(params[:user][:mosaic_ids])

    flash[:notice] = 'Successfully deleted pictures.'
    render 'show'
  end

  def destroy_all_by_ids(ids)
    ids and ids.each do |id|
      @picture = Picture.find(id)
      if not @picture.destroy
        raise 'Problem deleting a mosaic.'
      end
    end
  end

  def check_auth
    if current_user
      redirect_to new_mosaic_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :password_digest)
    end
end