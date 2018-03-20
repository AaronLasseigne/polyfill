RSpec.describe 'Hash#>' do
  using Polyfill(Hash: %w[#>], version: '2.3')

  it 'raises a TypeError if the right operand is not a hash' do
    expect { { a: 1 } > 1   }.to raise_error(TypeError)
    expect { { a: 1 } > nil }.to raise_error(TypeError)
    expect { { a: 1 } > []  }.to raise_error(TypeError)
    expect { { a: 1 } > BasicObject.new }.to raise_error(TypeError)
  end

  it 'returns false if both hashes have the same keys but different values' do
    h1 = { a: 1 }
    h2 = { a: 2 }

    expect(h1 > h2).to be false
    expect(h2 > h1).to be false
  end

  let(:h1) { { a: 1, b: 2, c: 3 } }
  let(:h2) { { a: 1, b: 2 } }

  it 'returns true if the other hash is a subset of self' do
    expect(h1 > h2).to be true
  end

  it 'returns false if the other hash is not a subset of self' do
    expect(h2 > h1).to be false
  end

  it 'converts the right operand to a hash before comparing' do
    o = Object.new
    def o.to_hash
      { a: 1, b: 2 }
    end

    expect(h1 > o).to be true
  end

  it 'returns false if both hashes are identical' do
    h = { a: 1, b: 2 }

    expect(h > h).to be false # rubocop:disable Lint/UselessComparison
  end

  let(:hash) { { a: 1, b: 2 } }
  let(:bigger) { { a: 1, b: 2, c: 3 } }
  let(:unrelated) { { c: 3, d: 4 } }
  let(:similar) { { a: 2, b: 3 } }

  it 'returns false when receiver size is smaller than argument' do
    expect(hash > bigger).to be false
    expect(unrelated > bigger).to be false
  end

  it 'returns false when receiver size is the same as argument' do
    expect(hash > hash).to be false # rubocop:disable Lint/UselessComparison
    expect(hash > unrelated).to be false
    expect(unrelated > hash).to be false
  end

  it 'returns true when argument is a subset of receiver' do
    expect(bigger > hash).to be true
  end

  it "returns false when keys match but values don't" do
    expect(hash > similar).to be false
    expect(similar > hash).to be false
  end
end
