RSpec.describe 'Float#ceil' do
  using Polyfill(Float: %w[#ceil])

  context 'existing behavior' do
    it 'returns the number as a rounded up integer' do
      expect((1.1).ceil).to eql 2
    end
  end

  context '2.4' do
    it 'does the existing behavior when called with 0' do
      expect((1.1).ceil(0)).to eql 2
    end

    it 'ceils up when called with > 0' do
      expect((1.15).ceil(1)).to eql 1.2
      expect((1.115).ceil(2)).to eql 1.12
    end

    it 'returns an integer and ceils up when called with < 0' do
      expect((15.0).ceil(-1)).to eql 20
      expect((15.0).ceil(-2)).to eql 100
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      expect(value).to receive(:to_int).and_return(1)
      (1.15).ceil(value)
    end
  end
end
