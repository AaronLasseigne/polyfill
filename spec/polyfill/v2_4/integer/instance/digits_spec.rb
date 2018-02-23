RSpec.describe 'Integer#digits' do
  using Polyfill(Integer: %w[#digits], version: '2.4')

  it 'returns a Math::DomainError for negative values' do
    expect { -1.digits }.to raise_error(Math::DomainError, 'out of domain')
  end

  it 'returns the digits in reverse order' do
    expect(12_345.digits).to eql [5, 4, 3, 2, 1]
  end

  context 'optional base argument' do
    it 'returns a ArgumentError for negative values' do
      expect { 0.digits(-1) }.to raise_error(ArgumentError, 'negative radix')
    end

    it 'returns a ArgumentError for invalid values' do
      expect { 0.digits(0) }.to raise_error(ArgumentError, 'invalid radix 0')
      expect { 0.digits(1) }.to raise_error(ArgumentError, 'invalid radix 1')
    end

    it 'returns the digits for the number after base conversion' do
      expect(12_345.digits(7)).to eql [4, 6, 6, 0, 5]
      expect(10.digits(16)).to eql [10]
      expect(12_345.digits(100)).to eql [45, 23, 1]
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      expect(value).to receive(:to_int).and_return(10)
      1.digits(value)
    end

    it 'raises a TypeError when given a non-Integer' do
      expect { 1.digits('a') }.to raise_error TypeError
    end
  end
end
