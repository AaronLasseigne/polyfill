RSpec.describe 'Hash#dig' do
  using Polyfill(Hash: %w[#dig])

  it 'returns #[] with one arg' do
    h = { 0 => false, a: 1 }
    expect(h.dig(:a)).to eql 1
    expect(h.dig(0)).to be false
    expect(h.dig(1)).to be nil
  end

  it 'returns the nested value specified by the sequence of keys' do
    h = { foo: { bar: { baz: 1 } } }
    expect(h.dig(:foo, :bar, :baz)).to eql 1
    expect(h.dig(:foo, :bar, :nope)).to be nil
    expect(h.dig(:foo, :baz)).to be nil
    expect(h.dig(:bar, :baz, :foo)).to be nil
  end

  it 'returns the nested value specified if the sequence includes an index' do
    h = { foo: [1, 2, 3] }
    expect(h.dig(:foo, 2)).to eql 3
  end

  it 'returns nil if any intermediate step is nil' do
    h = { foo: { bar: { baz: 1 } } }
    expect(h.dig(:foo, :zot, :xyz)).to be nil
  end

  it 'raises an ArgumentError if no arguments provided' do
    expect { { the: 'borg' }.dig }.to raise_error(ArgumentError)
  end

  it 'handles type-mixed deep digging' do
    h = {}
    h[:foo] = [{ bar: [1] }, [obj = Object.new, 'str']]
    def obj.dig(*)
      [42]
    end

    expect(h.dig(:foo, 0, :bar)).to eql [1]
    expect(h.dig(:foo, 0, :bar, 0)).to eql 1
    expect(h.dig(:foo, 1, 1)).to eql 'str'
    # MRI does not recurse values returned from `obj.dig`
    expect(h.dig(:foo, 1, 0, 0)).to eql [42]
    expect(h.dig(:foo, 1, 0, 0, 10)).to eql [42]
  end

  it 'raises TypeError if an intermediate element does not respond to #dig' do
    h = {}
    h[:foo] = [{ bar: [1] }, [nil, 'str']]
    expect { h.dig(:foo, 0, :bar, 0, 0) }.to raise_error(TypeError)
    expect { h.dig(:foo, 1, 1, 0) }.to raise_error(TypeError)
  end

  it 'calls #dig on the result of #[] with the remaining arguments' do
    h = { foo: { bar: { baz: 42 } } }
    allow(h[:foo]).to receive(:dig).with(:bar, :baz).and_return(42)

    expect(h.dig(:foo, :bar, :baz)).to eql 42
  end
end
