RSpec.describe PicturesController do
  
  describe '#new' do
    it 'returns an HTTP 200' do
      get :new

      expect(response.status).to eq(200)
    end
  end

  describe '#show' do
    it 'returns an HTTP 200' do
      User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      Picture.create(mosaic_id: 1)
      get :show, id: 1

      expect(response.status).to eq(200)
    end
  end

  describe '#delete_mosaic' do
    it 'returns an HTTP 200 when specifying ID' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      Picture.create(mosaic_id: 1)

      delete :delete_mosaic, mosaic: { id: 1 }

      expect(response.status).to eq(200)
    end

    it 'returns an HTTP 200 even when NOT specifying ID' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      session[:user_id] = user.id
      Picture.create(mosaic_id: 1)

      delete :delete_mosaic

      expect(response.status).to eq(200)
    end

    it 'returns an HTTP 401 when NOT specifying ID and user has no mosaics' do
      user = User.create(email: 'newaccount1@test.com', password: 1, password_confirmation: 1)
      session[:user_id] = user.id

      delete :delete_mosaic, id: 1

      expect(response.status).to eq(401)
    end
  end

  describe '#create' do
    it '' do
    end
  end

  describe '#upload' do
    it '' do
    end
  end

end