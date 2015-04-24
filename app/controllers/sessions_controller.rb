class SessionsController < ApplicationController
  respond_to :json, only: [:create, :destroy, :show]

  def create
    @user = User.find_by(email: session_params[:email])

    if @user and @user.authenticate(session_params[:password])
      sign_in @user
      render json: @user, status: 200
    else
      render json: nil, status: 401
    end
  end

  def destroy
    sign_out()
    render nothing: true, status: 204
  end

  def show
    if signed_in?
      respond_with current_user
    else
      render nothing: true, status: 404
    end
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