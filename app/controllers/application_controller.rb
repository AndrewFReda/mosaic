class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # placeholder method for backbone
  def index
  end

  private

    def current_user
      begin
        if session[:user_id]
          @current_user ||= User.find session[:user_id]
        end
      rescue ActiveRecord::RecordNotFound
      end
    end

  helper_method :current_user
end
