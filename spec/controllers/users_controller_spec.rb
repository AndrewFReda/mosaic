RSpec.describe UsersController do
  
  describe '#new' do
    it 'should create a new user' do
      get :new

      expect(response.status).to eq(200)
    end
  end

  describe '#show' do
    it 'should find a given user' do
      User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      get :show, id: 1

      expect(response.status).to eq(200)
    end
  end

  describe '#create' do
    it 'returns an HTTP 302 and creates the user on success' do
      post :create, user: { email: 'newaccount1@test.com', password: 1, password_confirmation: 1 }

      expect(response.status).to eq(302)
    end

    it 'returns an HTTP 401 when password and confirmation do not match' do
      post :create, user: { email: 'newaccount1@test.com', password: 1, password_confirmation: 2 }

      expect(response.status).to eq(401)
    end

    it 'returns an HTTP 400 when user with given email already exists' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :create, user: { email: 'newaccount1@test.com', password: 1, password_confirmation: 1 }

      expect(response.status).to eq(400)
    end
  end

  describe '#logout' do
    it 'log current user out by removing :user_id from session' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: user.password }
      expect(session[:user_id]).to eq(user.id)

      delete :logout

      expect(session[:user_id]).to eq(nil)
    end
  end

  describe '#login' do
    it 'returns an HTTP 200 indicating successful display of login form' do
      get :login

      expect(response.status).to eq(200)
    end
  end

  describe '#login_user' do
    it 'sets session ID equal to the current user ID on success' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: user.password }
      expect(session[:user_id]).to eq(user.id)
    end

    it 'returns an HTTP 302 and redirects to the new mosaic path on success' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: user.password }
      expect(response.status).to eq(302)
      expect(response).to redirect_to(new_mosaic_path)
    end

    it 'returns an HTTP 401 for failed login' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: 2 }
      expect(response.status).to eq(401)
    end
  end

  describe '#change_password' do
    it 'returns an HTTP 200 and updates the users password on success' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: user.password }

      new_password = 2
      post :change_password, user: { 
                              password: user.password, 
                              password_confirmation: user.password_confirmation,
                              new_password: new_password
                            }

      expect(response.status).to eq(200)

      delete :logout
      expect(session[:user_id]).to eq(nil)

      post :login_user, user: { email: user.email, password: new_password }
      expect(response.status).to eq(302)
    end

    it 'returns an HTTP 401 when password is incorrect' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: user.password }

      new_password = 2
      post :change_password, user: { 
                              password: new_password, 
                              password_confirmation: new_password,
                              new_password: user.password
                            }

      expect(response.status).to eq(401)
    end

    it 'returns an HTTP 401 when password and confirmation do not match' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: user.password }

      new_password = 2
      post :change_password, user: { 
                              password: new_password, 
                              password_confirmation: user.password,
                              new_password: new_password
                            }

      expect(response.status).to eq(401)
    end
  end

  describe '#delete_pictures' do
    it 'returns an HTTP 200 and deletes pictures specified from user' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      post :login_user, user: { email: user.email, password: user.password }

      # TODO add actual pictures to delete and check against them
      delete :delete_pictures, user: { composition_picture_ids: [], 
                                        base_picture_ids: [],
                                        mosaic_ids: [] 
                                      }

      expect(response.status).to eq(200)
    end
  end



#  describe '#bypass_auth' do
#    it 'returns an HTTP 302 and redirects for logged in users' do
#      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
#      post :login_user, user: { email: user.email, password: user.password }

#      get :check_auth

#      expect(response.status).to eq(200)
#    end

#    it 'returns an HTTP 200 and does nothing for non-logged in users' do
#      get :check_auth

#      expect(response.status).to eq(200)
#    end
#  end


end