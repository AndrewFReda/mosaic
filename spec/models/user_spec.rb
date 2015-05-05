RSpec.describe User do
  let(:user) { FactoryGirl.create :user_with_pictures  }

  describe '.find_pictures_by' do
    context 'when given a type for an arguement' do
      it 'responds with pictures of given type' do
        pictures = user.find_pictures_by type: user.pictures.first.type
        expect(pictures.length).to eq(1)
        expect(pictures.first).to eq(user.pictures.first)
      end
    end

    context 'when given ids for an arguement' do
      it 'responds with pictures with given ids' do
        pictures = user.find_pictures_by ids: [ user.pictures.first.id ]
        # TODO: come back to this test
        #expect(pictures.length).to eq(1)
        expect(pictures.first).to eq(user.pictures.first)
      end
    end

    context 'when given no arguement' do
      it 'responds with all pictures' do
        pictures = user.find_pictures_by
        expect(pictures.length).to eq(3)
        expect(pictures.to_a).to eq(user.pictures)
      end
    end
  end
end