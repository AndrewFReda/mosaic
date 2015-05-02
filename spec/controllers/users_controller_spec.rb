RSpec.describe UsersController, type: :controller do
  # Parse response JSON into variable
  let(:parsed_response) { JSON.parse response.body }
  # Designate all requests as JSON
  before(:example) { request.accept = "application/json" }

  let(:user)     { FactoryGirl.create :user }
  let(:new_user) { FactoryGirl.build  :user}

  # Tests
  ### Show ###
  describe '#show' do
    context 'when given a valid user ID' do
      it 'responds with an HTTP 200' do
        get :show, { id: user.id }

        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for given User' do
        get :show, { id: user.id }

        expect(response.body).to eq(user.to_json)
      end
    end

    context 'when given an invalid user ID' do
      # Stub method to ensure ID will be invalid
      before(:example) { allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound) }

      it 'responds with an HTTP 404' do
        get :show, { id: user.id }

        expect(response).to have_http_status(404)
      end

      it 'responds with a JSON error message' do
        get :show, { id: user.id }

        expect(parsed_response.keys.first).to eq('errors')
        expect(parsed_response.values.first).to eq("Unable to find User with ID: #{user.id}")
      end
    end
  end

  ### Create ###
  describe '#create' do
     context 'when given valid User attributes with no user existing for email' do
      it 'responds with an HTTP 200' do
        post :create, user: { email: new_user.email, password: new_user.password, password_confirmation: new_user.password_confirmation }

        expect(response).to have_http_status(201)
      end

      it 'responds with JSON for newly created user' do
        post :create, user: { email: new_user.email, password: new_user.password, password_confirmation: new_user.password_confirmation }

        # TODO: Make expect() ignore cases instead?
        new_user.update({
          id: parsed_response['id'],
          created_at: parsed_response['created_at'],
          updated_at: parsed_response['updated_at'],
          password_digest: parsed_response['password_digest']
        })

        expect(response.body).to include(new_user.to_json)
      end

      it 'does not create a new session' do
        post :create, user: { email: new_user.email, password: new_user.password, password_confirmation: new_user.password_confirmation }

        expect(session[:user_id]).to eq(nil)
      end
    end

    context 'when a user already exists with given email' do
      it 'responds with an HTTP 400' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation }

        expect(response).to have_http_status(400)
      end

      it 'responds with a JSON error message' do
        post :create, user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation }

        expect(parsed_response.keys.first).to eq('errors')
        expect(parsed_response.values.first).to eq('Email has already been taken')
      end
    end

    context 'when given password and confirmation do not match' do
      let(:wrong_confirmation) { "#{new_user.password}_wrong_ending"}
      
      it 'responds with an HTTP 401' do
        post :create, user: { email: new_user.email, password: new_user.password, password_confirmation: wrong_confirmation }

        expect(response).to have_http_status(401)
      end

      it 'responds with a JSON error message' do
        post :create, user: { email: new_user.email, password: new_user.password, password_confirmation: wrong_confirmation }

        expect(parsed_response.keys.first).to eq('errors')
        expect(parsed_response.values.first).to eq("Password confirmation doesn't match Password")
      end
    end
  end

  ### Update ###
  describe '#update' do
    let(:altered_email)    { "altered-#{user.email}" }
    let(:altered_password) { "altered-#{user.password}" }

     context 'when given valid User authentication information' do
      it 'responds with an HTTP 204' do
        put :update, { id: user.id, user: { email: user.email, password: user.password, new_password: altered_password } }

        expect(response).to have_http_status(204)
      end

      it 'responds with no content' do
        put :update, { id: user.id, user: { email: user.email, password: user.password, new_password: altered_password } }

        expect(response.body).to eq('')
      end

      it 'updates all given attributes for given User' do
        put :update, { id: user.id, user: { email: altered_email, password: user.password, new_password: altered_password } }

        get :show, id: user.id
        expect(parsed_response['email']).to eq(altered_email)

        # Hacky workaround test to ensure password changed
        put :update, { id: user.id, user: { email: user.email, password: altered_password } }
        get :show, id: user.id
        expect(parsed_response['email']).to eq(altered_email)
      end

      it 'updates only given attributes for given User' do
        put :update, { id: user.id, user: { password: user.password, new_password: altered_password } }
        
        get :show, id: user.id
        expect(parsed_response['email']).to eq(user.email)
      end
    end

    context 'when given password is incorrect' do
      it 'responds with an HTTP 401' do
        put :update, { id: user.id, user: { password: altered_password, new_password: altered_password } }

        expect(response).to have_http_status(401)
      end

      it 'responds with a JSON error message' do
        put :update, { id: user.id, user: { password: altered_password, new_password: altered_password, new_password_confirmation: altered_password } }

        expect(parsed_response.keys.first).to eq('errors')
        expect(parsed_response.values.first).to eq('Password is incorrect')
      end
    end
  end
end