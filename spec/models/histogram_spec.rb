RSpec.describe Histogram do
  let(:histogram) { Histogram.new }

  describe '.set-hue' do
    context 'when given an ImageMagick Image as an arguement' do
      it '' do
      end

      it '' do
      end
    end

    context 'when given an Integer representing the dominant hue' do
      let(:hue) { 1 }

      it 'sets the dominant_hue field' do
        histogram.set_hue dominant_hue: hue

        expect(histogram.dominant_hue).to eq(hue)
      end
    end
  end
end