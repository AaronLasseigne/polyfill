RSpec.describe 'Integer#truncate' do
  using Polyfill(Integer: %w[#truncate], version: '2.5')

  context 'existing behavior' do
    it 'returns itself' do
      expect(1.truncate).to eql 1
    end

    it 'returns itself when called with 0' do
      expect(1.truncate(0)).to eql 1
    end

    it 'truncates up when called with < 0' do
      expect(15.truncate(-1)).to eql 10
      expect(15.truncate(-2)).to eql 0
      expect(-15.truncate(-1)).to eql(-10)
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      expect(value).to receive(:to_int).and_return(1)
      1.truncate(value)
    end
  end

  context '2.5' do
    it 'returns itself when called with > 0' do
      expect(1.truncate(1)).to eql 1
      expect(1.truncate(2)).to eql 1
    end
  end
end
