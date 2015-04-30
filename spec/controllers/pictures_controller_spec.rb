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

    context 'when given a valid user ID' do
      it 'responds with an HTTP 200' do
        get :index, { user_id: user.id }

        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for pictures belonging to given user' do
        get :index, { user_id: user.id }

        # TODO: Catch times with a stubbed method?
        response_pictures = []
        json_response.each do |pic|
          response_pictures << FactoryGirl.build(:picture, pic)
        end

        expect(response_pictures).to eq(user.pictures)
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
        
        expect(response).to have_http_status(200)
      end

      it 'responds with JSON for access information to upload pictures to S3' do
        post :create, { user_id: user.id, picture: { name: picture.name, url: picture.url, type: picture.type, histogram: picture.histogram } }
        
        s3_keys = parsed_response.keys
        expect(s3_keys).to eq(['key', 'policy', 'signature', 'content_type', 'access_key'])
      end
    end

    context 'when not given valid name for Picture' do
      it 'responds with HTTP 500' do
        post :create, { user_id: user.id, picture: { type: picture.type } }

        expect(response).to have_http_status(500)
      end

      it 'responds with a JSON error message' do
        post :create, { user_id: user.id, picture: { type: picture.type } }

        expect(parsed_response.keys.first).to   eq('errors')
        expect(parsed_response.values.first).to eq('Unable to create picture')
      end
    end
  end
end