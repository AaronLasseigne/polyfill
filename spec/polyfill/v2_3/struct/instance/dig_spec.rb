RSpec.describe 'Struct#dig' do
  using Polyfill(Struct: %w[#dig], version: '2.3')

  let(:klass) { Struct.new(:a) }
  let(:instance) { klass.new(klass.new(b: [1, 2, 3])) }

  it 'returns the nested value specified by the sequence of keys' do
    expect(instance.dig(:a, :a)).to eql(b: [1, 2, 3])
  end

  it 'returns the nested value specified if the sequence includes an index' do
    expect(instance.dig(:a, :a, :b, 0)).to eql 1
  end

  it 'returns nil if any intermediate step is nil' do
    expect(instance.dig(:b, 0)).to be nil
  end

  it 'raises a TypeError if any intermediate step does not respond to #dig' do
    instance = klass.new(1)
    expect { instance.dig(:a, 3) }.to raise_error(TypeError)
  end

  it 'raises an ArgumentError if no arguments provided' do
    expect { instance.dig }.to raise_error(ArgumentError)
  end

  it 'calls #dig on any intermediate step with the rest of the sequence as arguments' do
    obj = Object.new
    instance = klass.new(obj)

    def obj.dig(*args)
      { dug: args }
    end

    expect(instance.dig(:a, :bar, :baz)).to eql(dug: %i[bar baz])
  end
end
