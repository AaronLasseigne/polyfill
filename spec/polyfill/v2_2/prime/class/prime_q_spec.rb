require 'prime'

RSpec.describe 'Prime.prime?' do
  using Polyfill(Prime: %w[.prime?], version: '2.2')

  context 'existing behavior' do
    it 'returns a true value for prime numbers' do
      expect(Prime.prime?(2)).to be true
      expect(Prime.prime?(3)).to be true
      expect(Prime.prime?(2**31 - 1)).to be true # 8th Mersenne prime (M8)
    end

    it 'returns a false value for composite numbers' do
      expect(Prime.prime?(4)).to be false
      expect(Prime.prime?(15)).to be false
      expect(Prime.prime?(2**32 - 1)).to be false
      expect(Prime.prime?((2**17 - 1) * (2**19 - 1))).to be false # M6*M7
    end
  end

  context '2.2' do
    it 'returns false for negative numbers' do
      expect(Prime.prime?(-2)).to be false
    end
  end
end
