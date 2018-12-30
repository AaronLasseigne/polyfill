RSpec.describe 'Hash#merge' do
  using Polyfill(Hash: %w[#merge], version: '2.6')

  it 'allows no arguments' do
    h = { one: 1 }
    h2 = h.merge

    expect(h).to eql h2
    expect(h.object_id).to_not eql h2.object_id
  end

  it 'allows multiple arguments' do
    h = {}
    h1 = { one: 1 }
    h2 = { two: 2 }

    expect(h.merge(h1)).to eql h1
    expect(h.merge(h1, h2)).to eql h1.merge(h2)
  end

  it 'returns a new hash by combining self with the contents of other' do
    h = { 1 => :a, 2 => :b, 3 => :c }.merge(a: 1, c: 2)
    expect(h).to eql(c: 2, 1 => :a, 2 => :b, a: 1, 3 => :c)

    hash = { a: 1, b: 2 }
    expect({}.merge(hash)).to eql hash
    expect(hash.merge({})).to eql hash

    h = { 1 => :a, 2 => :b, 3 => :c }.merge(1 => :b)
    expect(h).to eql(1 => :b, 2 => :b, 3 => :c)

    h = { 1 => :a, 2 => :b }.merge(1 => :b, 3 => :c)
    expect(h).to eql(1 => :b, 2 => :b, 3 => :c)
  end

  it 'sets any duplicate key to the value of block if passed a block' do
    h1 = { a: 2, b: 1, d: 5 }
    h2 = { a: -2, b: 4, c: -3 }
    r = h1.merge(h2) { |_k, _x, _y| nil }
    expect(r).to eql(a: nil, b: nil, c: -3, d: 5)

    r = h1.merge(h2) { |k, x, y| "#{k}:#{x + 2 * y}" }
    expect(r).to eql(a: 'a:-2', b: 'b:9', c: -3, d: 5)

    expect do
      h1.merge(h2) { |_k, _x, _y| raise(IndexError) }
    end.to raise_error(IndexError)

    r = h1.merge(h1) { |_k, _x, _y| :x }
    expect(r).to eql(a: :x, b: :x, d: :x)
  end

  it 'tries to convert the passed argument to a hash using #to_hash' do
    obj = double('{1=>2}')
    allow(obj).to receive(:to_hash).and_return(1 => 2)

    expect({ 3 => 4 }.merge(obj)).to eql(1 => 2, 3 => 4)
  end

  it 'does not call to_hash on hash subclasses' do
    my_hash = Class.new(Hash)

    expect({ 3 => 4 }.merge(my_hash[1 => 2])).to eql(1 => 2, 3 => 4)
  end

  it 'returns subclass instance for subclasses' do
    my_hash = Class.new(Hash)

    expect(my_hash[1 => 2, 3 => 4].merge(1 => 2)).to be_an_instance_of(my_hash)
    expect(my_hash[].merge(1 => 2)).to be_an_instance_of(my_hash)

    expect({ 1 => 2, 3 => 4 }.merge(my_hash[1 => 2]).class).to eql Hash
    expect({}.merge(my_hash[1 => 2]).class).to eql Hash
  end

  it 'processes entries with same order as each()' do
    h = { 1 => 2, 3 => 4, 5 => 6, 'x' => nil, nil => 5, [] => [] }
    merge_pairs = []
    each_pairs = []
    h.each_pair { |k, v| each_pairs << [k, v] }
    h.merge(h) { |k, v1, _v2| merge_pairs << [k, v1] }

    expect(merge_pairs).to eql each_pairs
  end
end
