class UsersController < ApplicationController
  include Histogramr

  respond_to :json, only: [:show, :create, :update_password]

  def show
    # TODO: Should this just be 'current_user' instead?
    @user = User.find params[:id]
    respond_with @user, status: 200
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Unable to find User with ID: #{params[:id]}" }, status: 404
  end

  # Creates User without creating Session
  # Explicit call to create Session required
  def create
    @user = User.new user_params

    if @user.save
      respond_with @user, status: 200
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

  def update_password
    # TODO: Should this just be 'current_user' instead?
    @user = User.find params[:id]

    if user_params[:password] == user_params[:password_confirmation]
      if @user.authenticate user_params[:password]
        if @user.update password: user_params[:new_password]
          # success
          head status: 204
        else
          # failure to update password
          render json: { errors: 'Failed to update password' }, status: 500
        end
      else
        # password is incorrect
        render json: { errors: 'Password is incorrect' }, status: 401
      end
    else
      # password and confirmation do not match
      render json: { errors: 'Password and confirmation do not match' }, status: 401
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :new_password, :password_digest)
    end




  ################################### Not implemented ###################################


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

  # http://stackoverflow.com/questions/14054164/rails-simple-form-getting-an-empty-string-from-checkbox-collection
  def clean_ids(ids)
    ids.delete_if { |id| id.empty? }
  end
end