RSpec.describe PicturesController, type: :controller do
  # Parse response JSON into variable
  let(:parsed_response) { JSON.parse response.body }
  # Designate all requests as JSON
  before(:example) { request.accept = "application/json" }

  let(:user) { FactoryGirl.build_stubbed :user }
  # Stub User.find since it is outside scope of tests
  before(:example) { allow(User).to receive(:find).and_return(user) }


  # --- Tests --- #

  ##### INDEX #####
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

  ##### CREATE #####
  describe '#create' do
    let(:picture) { FactoryGirl.build :picture }

    context 'when given valid Pictures attributes' do
      it 'responds with an HTTP 200' do
        post :create, { user_id: user.id, picture: { name: picture.name, url: picture.url, type: picture.type, histogram: picture.histogram } }
        
        expect(response).to have_http_status(201)
      end

      it 'responds with JSON for access information to upload pictures to S3' do
        post :create, { user_id: user.id, picture: { name: picture.name, url: picture.url, type: picture.type, histogram: picture.histogram } }
        
        upload_keys = parsed_response.keys
        s3_keys     = parsed_response['s3_upload'].keys
        expect(upload_keys).to eq(['s3_upload', 'picture'])
        expect(s3_keys).to eq(['key', 'policy', 'signature', 'content_type', 'access_key'])
      end
    end

    context 'when given invalid Picture attributes' do
      it 'responds with an HTTP 500' do
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

  ##### UPDATE #####
  describe '#update' do
    let(:picture) { FactoryGirl.create :picture } 

    context 'when given all valid Picture attributes' do
      let(:updated_name) { "updated_#{picture.name}" }

      it 'responds with an HTTP 204' do
        put :update, { user_id: user.id, id: picture.id, picture: { id: picture.id, name: updated_name } }

        expect(response).to have_http_status(204)
      end

      it 'responds with no JSON content' do
        put :update, { user_id: user.id, id: picture.id, picture: { id: picture.id, name: updated_name }}

        expect(response.body).to eq('')
      end
    end

    context 'when given invalid Picture attributes to update' do
      let(:updated_name) { "" }

      it 'responds with an HTTP 500' do
        put :update, { user_id: user.id, id: picture.id, picture: { id: picture.id, name: updated_name }}

        expect(response).to have_http_status(500)
      end

      it 'responds with a JSON error message' do
        put :update, { user_id: user.id, id: picture.id, picture: { id: picture.id, name: updated_name }}        

        expect(parsed_response.keys.first).to   eq('errors')
        expect(parsed_response.values.first).to eq("Name can't be blank")
      end
    end
  end

  ##### DESTROY #####
  describe '#destroy' do
    let(:picture) { FactoryGirl.create :picture }
    # TODO: Make tests more robust
    context 'when given valid Picture' do
      it 'responds with an HTTP 204' do
        delete :destroy, { user_id: user.id, id: picture.id }

        expect(response).to have_http_status(204)
      end

      it 'responds with no JSON' do
        delete :destroy, { user_id: user.id, id: picture.id }

        expect(response.body).to eq('')
      end
    end

    # TODO: Fix tests
    #context 'when given valid Picture but destroy fails' do
    #  before(:example) { allow(Picture).to receive(:destroy).and_return(false) }

    #  it 'responds with an HTTP 500' do
    #    delete :destroy, { user_id: user.id, id: picture.id }

    #    expect(response).to have_http_status(500)
    #  end

    #  it 'responds with JSON error message' do
    #    delete :destroy, { user_id: user.id, id: picture.id }

    #    expect(response.body).to eq('')
    #  end
    #end
  end


  # --- before_action Tests --- #
  
  ##### FIND_USER #####
  describe('.find_user') do
    context 'when given an invalid user ID' do
      let(:picture) { FactoryGirl.build_stubbed :picture }
      # Stub method to ensure ID will be invalid
      before(:example) { allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound) }

      it '#index responds with an HTTP 404' do
        get :index, { user_id: user.id }

        expect(response).to have_http_status(404)
      end

      it '#create responds with an HTTP 404' do
        post :create, { user_id: user.id }

        expect(response).to have_http_status(404)
      end

      it '#update responds with an HTTP 404' do
        get :update, { user_id: user.id, id: picture.id }

        expect(response).to have_http_status(404)
      end

      it '#destroy responds with an HTTP 404' do
        delete :destroy, { user_id: user.id, id: picture.id }

        expect(response).to have_http_status(404)
      end

      it 'responds with a JSON error message' do
        get :index, { user_id: user.id }

        expect(parsed_response.keys.first).to eq('errors')
        expect(parsed_response.values.first).to eq("Unable to find User with ID: #{user.id}")
      end
    end
  end

  ##### FIND_PICTURE #####
  describe('.find_picture') do
    context 'when given invalid Picture to update' do
      let(:user) { FactoryGirl.create :user }
      let(:picture) { FactoryGirl.build_stubbed :picture }
      # Stub method to ensure ID will be invalid
      before(:example) { allow(Picture).to receive(:find).and_raise(ActiveRecord::RecordNotFound) }

      it '#update responds with an HTTP 500' do
        put :update, { user_id: user.id, id: picture.id, picture: { name: picture.name } }

        expect(response).to have_http_status(404)
      end

      it '#destroy responds with an HTTP 500' do
        delete :destroy, { user_id: user.id, id: picture.id }

        expect(response).to have_http_status(404)
      end

      it 'responds with a JSON error message' do
        put :update, { user_id: user.id, id: picture.id, picture: { name: picture.name } }

        expect(parsed_response.keys.first).to   eq('errors')
        expect(parsed_response.values.first).to eq("Unable to find Picture with ID: #{picture.id}")
      end
    end
  end
end