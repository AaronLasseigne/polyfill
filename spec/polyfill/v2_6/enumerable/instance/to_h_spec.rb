RSpec.describe 'Enumerable#to_h' do
  let(:klass) do
    Class.new do
      include Enumerable
      include Polyfill.get(Enumerable, %i[to_h], version: '2.6')

      def each
        yield [:a, 1]
        yield [:b, 2]
      end
    end.new
  end

  it 'allows no arguments' do
    expect(klass.to_h).to eql(a: 1, b: 2)
  end

  context 'with block' do
    it 'converts [key, value] pairs returned by the block to a Hash' do
      expect(klass.to_h { |(k, _)| [k, k.to_s] }).to eql(a: 'a', b: 'b')
    end

    it 'raises ArgumentError if block returns longer or shorter array' do
      expect do
        klass.to_h { |(k, _)| [k, k.to_s, 1] }
      end.to raise_error(ArgumentError, 'wrong array length at 0 (expected 2, was 3)')

      expect do
        klass.to_h { |(k, _)| [k] }
      end.to raise_error(ArgumentError, 'wrong array length at 0 (expected 2, was 1)')
    end

    it 'raises TypeError if block returns something other than Array' do
      expect do
        klass.to_h { |_| 'not-array' }
      end.to raise_error(TypeError, 'wrong element type String at 0 (expected array)')
    end

    it 'coerces returned pair to Array with #to_ary' do
      x = Class.new do
        def to_ary
          [:b, 'b']
        end
      end.new

      expect(klass.to_h { |_| x }).to eql(b: 'b')
    end

    it 'does not coerce returned pair to Array with #to_a' do
      x = Class.new do
        def to_a
          [:b, 'b']
        end
      end.new

      expect do
        klass.to_h { |_| x }
      end.to raise_error(TypeError, /wrong element type .+ at 0/)
    end
  end
end
