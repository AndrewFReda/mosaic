RSpec.describe SessionsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  # Designate all requests as JSON
  before(:example) { request.accept = "application/json" }

  # Helper methods
  def login(login_user)
    #post :create, session: { email: user.email, password: user.password }
    session[:user_id] = login_user.id
  end

  def json_response
    JSON.parse(response.body)
  end

  # Tests
  ### Show ###
  describe '#show' do
    context 'when a user is signed in' do
      before(:each) { login(user) }

      it 'responds with an HTTP 200' do
        get :show

        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for the signed in user' do
        get :show

        expect(response.body).to eq(user.attributes.to_json)
      end
    end

    context 'when a user is not signed in' do
      it 'responds with an HTTP 404' do
        get :show

        expect(response).to have_http_status(404)
      end

      it 'responds with a JSON error message' do
        get :show

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq('Session does not exist')
      end
    end
  end

  ### Create ###
  describe '#create' do
    context 'when a user exists for given email and password' do
      it 'responds with an HTTP 200' do
        post :create, session: { email: user.email, password: user.password }

        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for the newly logged in user' do
        post :create, session: { email: user.email, password: user.password }

        expect(response.body).to eq(user.attributes.to_json)
      end

      it 'sets session ID to user ID' do
        expect(session[:user_id]).to eq(nil)

        post :create, session: { email: user.email, password: user.password }

        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when no user exists for given email' do
      let(:wrong_email) { "_wrong#{user.email}" }

      it 'responds with an HTTP 401' do
        post :create, session: { email: wrong_email, password: user.password }

        expect(response).to have_http_status(401)
      end

      it 'responds with a JSON error messagge' do
        post :create, session: { email: wrong_email, password: user.password }

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq('Unable to create session')
      end
    end

    context 'when given password and email do not match' do
      let(:wrong_password) { "_wrong_#{user.password}" }

      it 'responds an with HTTP 401' do
        post :create, session: { email: user.email, password: wrong_password }

        expect(response).to have_http_status(401)
      end

      it 'responds with a JSON error message' do
        post :create, session: { email: user.email, password: wrong_password }

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq('Unable to create session')
      end
    end
  end

  ### Destroy ###
  describe '#destroy' do
    context 'when a user is logged in' do
      before(:each) { login(user) }

      it 'responds with an HTTP 204' do
        delete :destroy

        expect(response).to have_http_status(204)
      end

      it 'responds with no content' do
        delete :destroy

        expect(response.body).to eq("")
      end

      it 'sets session ID to nil' do
        delete :destroy

        expect(session[:user_id]).to eq(nil)
      end
    end

    context 'when a user is already logged out' do

      it 'responds with an HTTP 204' do
        delete :destroy

        expect(response).to have_http_status(204)
      end

      it 'responds with no content' do
        delete :destroy

        expect(response.body).to eq("")
      end

      it 'sets session ID to nil' do
        delete :destroy

        expect(session[:user_id]).to eq(nil)
      end
    end
  end
end