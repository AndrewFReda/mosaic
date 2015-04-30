RSpec.describe Picture do
  let(:picture) { FactoryGirl.build :picture }

  describe '#getContentType' do
    it 'returns correct content type' do
      contentType = picture.getContentType()

      expect(contentType).to eq('image/png')
    end
  end

end