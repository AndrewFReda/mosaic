class UsersController < ApplicationController

  before_action :find_user, only: [:show, :update]
  respond_to :json, only: [:show, :create, :update]

  def show
    respond_with @user, status: 200
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Unable to find User with ID: #{params[:id]}" }, status: 404
  end

  # Creates User without creating Session
  # Explicit call to create Session required
  def create
    @user = User.new user_params

    if @user.save
      respond_with @user, status: 201
    else
      if @user.errors[:email].empty?
        # password and confirmation do not match
        render json: { errors: @user.errors.full_messages.first }, status: 401
      else
        # user with this email already exists
        render json: { errors: @user.errors.full_messages.first }, status: 400
      end
    end
  end

  def update
    email = user_params[:email]        || @user.email
    pswrd = user_params[:new_password] || @user.password

    if @user.authenticate user_params[:password]
      if @user.update email: email, password: pswrd
        head status: 204
      else
        render json: { errors: @user.errors.full_messages }, status: 500
      end
    else
      render json: { errors: 'Password is incorrect' }, status: 401
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :new_password, :password_digest)
    end

    def find_user
      # TODO: Should this just be 'current_user' instead?
      @user = User.find params[:id]
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "Unable to find User with ID: #{params[:id]}" }, status: 404
    end

end