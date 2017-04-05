RSpec.describe 'Hash#fetch_values' do
  using Polyfill(Hash: %w[#fetch_values])

  let(:hash) { { a: 1, b: 2, c: 3 } }

  describe 'with matched keys' do
    it 'returns the values for keys' do
      expect(hash.fetch_values(:a)).to eql [1]
      expect(hash.fetch_values(:a, :c)).to eql [1, 3]
    end
  end

  describe 'with unmatched keys' do
    it 'raises a KeyError' do
      expect { hash.fetch_values :z }.to raise_error(KeyError)
      expect { hash.fetch_values :a, :z }.to raise_error(KeyError)
    end

    it 'returns the default value from block' do
      expect(hash.fetch_values(:z) { |key| "`#{key}' is not found" }).to eql ["`z' is not found"]
      expect(hash.fetch_values(:a, :z) { |key| "`#{key}' is not found" }).to eql [1, "`z' is not found"]
    end
  end

  describe 'without keys' do
    it 'returns an empty Array' do
      expect(hash.fetch_values).to eql []
    end
  end
end
