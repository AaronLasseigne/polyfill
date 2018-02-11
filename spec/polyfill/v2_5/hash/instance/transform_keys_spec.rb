RSpec.describe 'Hash#transform_keys' do
  using Polyfill(Hash: %w[#transform_keys], version: '2.5')

  let(:hash) { { a: 1, b: 2, c: 3 } }

  it 'returns new hash' do
    ret = hash.transform_keys(&:succ)

    expect(ret).to_not equal(hash)
    expect(ret).to be_an_instance_of(Hash)
  end

  it 'sets the result as transformed keys with the given block' do
    expect(hash.transform_keys(&:succ)).to eql(b: 1, c: 2, d: 3)
  end

  it 'keeps last pair if new keys conflict' do
    expect(hash.transform_keys { |_| :a }).to eql(a: 3)
  end

  it 'makes both hashes to share values' do
    value = [1, 2, 3]
    new_hash = { a: value }.transform_keys(&:upcase)

    expect(new_hash[:A]).to equal(value)
  end

  context 'when no block is given' do
    it 'returns a sized Enumerator' do
      enumerator = hash.transform_keys

      expect(enumerator).to be_an_instance_of(Enumerator)
      expect(enumerator.size).to eql hash.size
      expect(enumerator.each(&:succ)).to eql(b: 1, c: 2, d: 3)
    end
  end

  it 'returns a Hash instance, even on subclasses' do
    klass = Class.new(Hash)
    h = klass.new
    h[:foo] = 42
    r = h.transform_keys { |v| :"x#{v}" }

    expect(r.keys).to eql [:xfoo]
    expect(r.class).to eql Hash
  end
end
