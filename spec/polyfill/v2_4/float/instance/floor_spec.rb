RSpec.describe 'Float#floor' do
  using Polyfill(Float: %w[#floor])

  context 'existing behavior' do
    it 'returns the number as a rounded up integer' do
      expect((1.1).floor).to eql 1
    end
  end

  context '2.4' do
    it 'does the existing behavior when called with 0' do
      expect((1.1).floor(0)).to eql 1
    end

    it 'floors down when called with > 0' do
      expect((1.15).floor(1)).to eql 1.1
      expect((1.115).floor(2)).to eql 1.11
    end

    it 'returns an integer and floors down when called with < 0' do
      expect((15.0).floor(-1)).to eql 10
      expect((15.0).floor(-2)).to eql 0
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      expect(value).to receive(:to_int).and_return(1)
      (1.15).floor(value)
    end
  end
end
