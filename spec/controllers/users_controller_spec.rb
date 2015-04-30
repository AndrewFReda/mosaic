RSpec.describe UsersController, type: :controller do
  # Designate all requests as JSON
  before(:example) { request.accept = "application/json" }

  # Helper methods
  def json_response
    JSON.parse(response.body)
  end

  # Tests
  ### Show ###
  describe '#show' do
    let(:user) { FactoryGirl.create :user }

    context 'when given a valid user ID' do
      it 'responds with an HTTP 200' do
        get :show, { id: user.id }

        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for given User' do
        get :show, { id: user.id }

        response_user = FactoryGirl.build(:user, json_response)

        expect(response_user).to eq(user)
      end
    end

    context 'when given an invalid user ID' do
      let(:invalid_id) { -1 }

      it 'responds with an HTTP 404' do
        get :show, { id: invalid_id }

        expect(response).to have_http_status(404)
      end

      it 'responds with a JSON error message' do
        get :show, { id: invalid_id }

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq("Unable to find User with ID: #{invalid_id}")
      end
    end
  end

  ### Create ###
  describe '#create' do
     context 'when given valid User attributes with no user existing for email' do
      let(:user) { FactoryGirl.build :user }

      it 'responds with an HTTP 200' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation }

        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for newly created user' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation }

        # TODO: Catch times with a stubbed method?
        user_attrs = user.attributes
        #user_attrs['id'] = json_response['id']
        #user_attrs['created_at'] = json_response['created_at']#user.created_at.iso8601(3)
        #user_attrs['updated_at'] = json_response['updated_at']#user.updated_at.iso8601(3)
        #user_attrs['password_digest'] = json_response['password_digest']

        # TODO: Figure out how build from FactoryGirl
        response_user = FactoryGirl.build(:user, json_response)

        expect(response_user).to eq(user)
      end

      it 'does not create a new session' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation }, id: user.id

        expect(session[:user_id]).to eq(nil)
      end
    end

    context 'when a user already exists with given email' do
      let(:user) { FactoryGirl.create :user }

      it 'responds with an HTTP 400' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation }

        expect(response).to have_http_status(400)
      end

      it 'responds with a JSON error message' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation }

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq('Email has already been taken')
      end
    end

    context 'when given password and confirmation do not match' do
      let(:user) { FactoryGirl.build :user }
      let(:wrong_confirmation) { "#{user.password}_wrong_ending"}
      
      it 'responds with an HTTP 401' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: wrong_confirmation }

        expect(response).to have_http_status(401)
      end

      it 'responds with a JSON error message' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: wrong_confirmation }

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq("Password confirmation doesn't match Password")
      end
    end
  end

  ### Update Password ###
  describe '#update_password' do
    let (:user) { FactoryGirl.create :user }
    let (:altered_password) { "altered-#{user.password}" }

     context 'when given valid User authentication information' do
      it 'responds with an HTTP 204' do
        put :update_password, { id: user.id, user: { password: user.password, password_confirmation: user.password_confirmation, new_password: altered_password } }

        expect(response).to have_http_status(204)
      end

      it 'responds with no content' do
        put :update_password, { id: user.id, user: { password: user.password, password_confirmation: user.password_confirmation, new_password: altered_password } }

        expect(response.body).to eq('')
      end

      it 'updates password for given User' do
      end
    end

    context 'when given password and confirmation do not match' do
      it 'responds with am HTTP 401' do
        put :update_password, { id: user.id, user: { password: user.password, password_confirmation: altered_password, new_password: altered_password } }

        expect(response).to have_http_status(401)
      end

      it 'responds with a JSON error message' do
        put :update_password, { id: user.id, user: { password: user.password, password_confirmation: altered_password, new_password: altered_password } }

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq('Password and confirmation do not match')
      end
    end

    context 'when given password is incorrect' do
      it 'responds with an HTTP 401' do
        put :update_password, { id: user.id, user: { password: altered_password, password_confirmation: altered_password, new_password: altered_password } }

        expect(response).to have_http_status(401)
      end

      it 'responds with a JSON error message' do
        put :update_password, { id: user.id, user: { password: altered_password, password_confirmation: altered_password, new_password: altered_password } }

        expect(json_response.keys.first).to eq('errors')
        expect(json_response.values.first).to eq('Password is incorrect')
      end
    end
  end
end