RSpec.describe Picture do
  let(:picture) { FactoryGirl.build :picture }

  describe '#get_content_type' do
    it 'returns correct content type' do
      contentType = picture.get_content_type()

      expect(contentType).to eq('image/png')
    end
  end

end