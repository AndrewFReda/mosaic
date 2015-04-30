class SessionsController < ApplicationController
  respond_to :json, only: [:show, :create, :destroy]

  def show
    if signed_in?
      respond_with current_user, status: 200
    else
      render json: { errors: 'Session does not exist' }, status: 404
    end
  end

  # TODO: Create session token to pass to user for authenticated requests
  def create
    @user = User.find_by email: session_params[:email]

    if @user and @user.authenticate(session_params[:password])
      sign_in @user
      render json: @user, status: 201
    else
      render json: { errors: 'Unable to create session' }, status: 401
    end
  end

  def destroy
    sign_out()
    head status: 204
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end

    def sign_in(user)
      session[:user_id] = @user.id
    end

    def sign_out
      session[:user_id] = nil
      @_current_user    = nil
    end

    def signed_in?
      current_user
    end

end