RSpec.describe Picture do

  describe '#getContentType' do
    it 'returns correct content type' do
      picture = FactoryGirl.build(:picture)
      contentType = picture.getContentType()

      expect(contentType).to eq('image/png')
    end
  end

end