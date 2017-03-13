RSpec.describe 'Integer#floor' do
  using Polyfill::V2_4::Integer::Floor

  context 'existing behavior' do
    it 'returns itself' do
      expect(1.floor).to eql 1
    end
  end

  context '2.4' do
    it 'returns itself when called with 0' do
      expect(1.floor(0)).to eql 1
    end

    it 'returns a float of the number when called with > 0' do
      expect(1.floor(1)).to eql 1.0
    end

    it 'floors down when called with < 0' do
      expect(15.floor(-1)).to eql 10
      expect(15.floor(-2)).to eql 0
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      allow(value).to receive(:to_int).and_return(1)
      expect(1.floor(value)).to eql 1.0
    end
  end
end
