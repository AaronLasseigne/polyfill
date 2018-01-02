RSpec.describe 'Float#truncate' do
  using Polyfill(Float: %w[#truncate], version: '2.4')

  context 'existing behavior' do
    it 'returns itself' do
      expect(1.1.truncate).to eql 1
    end
  end

  context '2.4' do
    it 'returns itself when called with 0' do
      expect(1.1.truncate(0)).to eql 1
    end

    it 'truncates when called with > 0' do
      expect(1.15.truncate(1)).to eql 1.1
      expect(1.115.truncate(2)).to eql 1.11
    end

    it 'returns an integer and truncates when called with < 0' do
      expect(15.0.truncate(-1)).to eql 10
      expect(15.0.truncate(-2)).to eql 0
      expect(-15.0.truncate(-1)).to eql(-10)
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      expect(value).to receive(:to_int).and_return(1)
      1.15.truncate(value)
    end
  end
end
