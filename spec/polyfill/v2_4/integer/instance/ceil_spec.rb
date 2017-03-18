RSpec.describe 'Integer#ceil' do
  using Polyfill(Integer: %w[#ceil])

  context 'existing behavior' do
    it 'returns itself' do
      expect(1.ceil).to eql 1
    end
  end

  context '2.4' do
    it 'returns itself when called with 0' do
      expect(1.ceil(0)).to eql 1
    end

    it 'returns a float of the number when called with > 0' do
      expect(1.ceil(1)).to eql 1.0
    end

    it 'ceils up when called with < 0' do
      expect(15.ceil(-1)).to eql 20
      expect(15.ceil(-2)).to eql 100
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      expect(value).to receive(:to_int).and_return(1)
      1.ceil(value)
    end
  end
end
