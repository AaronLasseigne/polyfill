RSpec.describe 'Hash#slice' do
  using Polyfill(Hash: %w[#slice], version: '2.5')

  let(:hash) { { a: 1, b: 2, c: 3 } }

  it 'returns new hash' do
    ret = hash.slice

    expect(ret).to_not equal(hash)
    expect(ret).to be_an_instance_of(Hash)
  end

  it 'returns the requested subset' do
    expect(hash.slice(:c, :a)).to eql(c: 3, a: 1)
  end

  it 'returns a hash ordered in the order of the requested keys' do
    expect(hash.slice(:c, :a).keys).to eql %i[c a]
  end

  it 'returns only the keys of the original hash' do
    expect(hash.slice(:a, :chunky_bacon)).to eql(a: 1)
  end

  it 'returns a Hash instance, even on subclasses' do
    klass = Class.new(Hash)
    h = klass.new
    h[:foo] = 42
    r = h.slice(:foo)

    expect(r).to eql(foo: 42)
    expect(r.class).to eql Hash
  end
end
