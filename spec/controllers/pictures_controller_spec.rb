RSpec.describe PicturesController, type: :controller do
  # Parse response JSON into variable
  let(:parsed_response) { JSON.parse response.body }
  # Designate all requests as JSON
  before(:example) { request.accept = "application/json" }

  # Stub User.find since it is outside scope of tests
  # Needed for create since no User exists due to build_stubbed :user 
  before(:example) { allow(User).to receive(:find).and_return(user) }

  # Tests
  ### Index ###
  describe '#index' do
    let(:user) { FactoryGirl.create :user_with_pictures }

    context 'when given only a valid user ID' do
      it 'responds with an HTTP 200' do
        get :index, { user_id: user.id }
        
        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for pictures belonging to given user' do
        get :index, { user_id: user.id }
        
        expect(response.body).not_to be_empty
        expect(response.body).to eq(user.pictures.to_json)
      end
    end

    context 'when given a valid user ID and picture type' do
      it 'responds with an HTTP 200' do
        get :index, { user_id: user.id, type: 'composition' }

        expect(response).to have_http_status(200)
      end

      it "responds with JSON for 'composition' pictures belonging to given user" do
        get :index, { user_id: user.id, type: 'composition' }

        filtered_user_pictures = user.pictures.select { |p| p.type == 'composition' }

        expect(response.body).not_to be_empty
        expect(response.body).to eq(filtered_user_pictures.to_json)
      end

      it "responds with JSON for 'base' pictures belonging to given user" do
        get :index, { user_id: user.id, type: 'base' }

        filtered_user_pictures = user.pictures.select { |p| p.type == 'base' }

        expect(response.body).not_to be_empty
        expect(response.body).to eq(filtered_user_pictures.to_json)
      end

      it "responds with JSON for 'mosaic' pictures belonging to given user" do
        get :index, { user_id: user.id, type: 'mosaic' }

        filtered_user_pictures = user.pictures.select { |p| p.type == 'mosaic' }

        expect(response.body).not_to be_empty
        expect(response.body).to eq(filtered_user_pictures.to_json)
      end
    end

    context 'when given an invalid user ID' do
      # Stub method to ensure ID will be invalid
      before(:example) { allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound) }

      it 'responds with an HTTP 404' do
        get :index, { user_id: user.id }

        expect(response).to have_http_status(404)
      end

      it 'responds with a JSON error message' do
        get :index, { user_id: user.id }

        expect(parsed_response.keys.first).to eq('errors')
        expect(parsed_response.values.first).to eq("Unable to find User with ID: #{user.id}")
      end
    end

    context 'when given a valid user ID and invalid picture type' do
      let(:invalid_type) { '_fake_type' }

      it 'responds with an HTTP 404' do
        get :index, { user_id: user.id, type: invalid_type }

        expect(response).to have_http_status(404)
      end

      it 'responds with a JSON error message' do
        get :index, { user_id: user.id, type: invalid_type }

        expect(parsed_response.keys.first).to eq('errors')
        expect(parsed_response.values.first).to eq('Type must be one of: composition, base, mosaic')
      end
    end
  end

  ### Create ###
  describe '#create' do
    let(:user)    { FactoryGirl.build_stubbed :user }
    let(:picture) { FactoryGirl.build :picture }

    context 'when given valid Pictures attributes' do
      it 'responds with an HTTP 200' do
        post :create, { user_id: user.id, picture: { name: picture.name, url: picture.url, type: picture.type, histogram: picture.histogram } }
        
        expect(response).to have_http_status(201)
      end

      it 'responds with JSON for access information to upload pictures to S3' do
        post :create, { user_id: user.id, picture: { name: picture.name, url: picture.url, type: picture.type, histogram: picture.histogram } }
        
        s3_keys = parsed_response.keys
        expect(s3_keys).to eq(['key', 'policy', 'signature', 'content_type', 'access_key'])
      end
    end

    context 'when given invalid Picture attributes' do
      it 'responds with HTTP 500' do
        post :create, { user_id: user.id, picture: { type: picture.type } }

        expect(response).to have_http_status(500)
      end

      it 'responds with appropriate JSON error message' do
        post :create, { user_id: user.id, picture: { type: picture.type } }

        expect(parsed_response.keys.first).to   eq('errors')
        expect(parsed_response.values.first).to eq("Name can't be blank")
      end

      it 'responds with appropriate JSON error message' do
        post :create, { user_id: user.id, picture: { name: '_fake.png', type: '_fake_type' } }

        expect(parsed_response.keys.first).to   eq('errors')
        expect(parsed_response.values.first).to eq('Type must be one of: composition, base, mosaic')
      end
    end
  end
end