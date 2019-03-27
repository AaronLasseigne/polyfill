RSpec.describe 'Hash#to_h' do
  using Polyfill(Hash: %w[#to_h], version: '2.6')

  it 'allows no arguments' do
    h = { one: 1 }
    h2 = h.to_h

    expect(h).to eql h2
    expect(h.object_id).to eql h2.object_id
  end

  context 'with block' do
    it 'converts [key, value] pairs returned by the block to a hash' do
      expect({ a: 1, b: 2 }.to_h { |k, v| [k.to_s, v * v] }).to eql('a' => 1, 'b' => 4)
    end

    it 'raises ArgumentError if block returns longer or shorter array' do
      expect do
        { a: 1, b: 2 }.to_h { |k, v| [k.to_s, v * v, 1] }
      end.to raise_error(ArgumentError, 'element has wrong array length (expected 2, was 3)')

      expect do
        { a: 1, b: 2 }.to_h { |k, _| [k] }
      end.to raise_error(ArgumentError, 'element has wrong array length (expected 2, was 1)')
    end

    it 'raises TypeError if block returns something other than Array' do
      expect do
        { a: 1, b: 2 }.to_h { |_, _| 'not-array' }
      end.to raise_error(TypeError, 'wrong element type String (expected array)')
    end

    it 'coerces returned pair to Array with #to_ary' do
      x = Class.new do
        def to_ary
          [:b, 'b']
        end
      end.new

      expect({ a: 1 }.to_h { |_| x }).to eql(b: 'b')
    end

    it 'does not coerce returned pair to Array with #to_a' do
      x = Class.new do
        def to_a
          [:b, 'b']
        end
      end.new

      expect do
        { a: 1 }.to_h { |_| x }
      end.to raise_error(TypeError, /wrong element type .+ \(expected array\)/)
    end
  end
end
