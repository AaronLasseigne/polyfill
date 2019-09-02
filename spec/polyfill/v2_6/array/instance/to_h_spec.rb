RSpec.describe 'Array#to_h' do
  using Polyfill(Array: %w[#to_h], version: '2.6')

  it 'allows no arguments' do
    array = [[:a, 1], [:b, 2]].to_h

    expect(array.to_h).to eql(a: 1, b: 2)
  end

  context 'with block' do
    it 'converts [key, value] pairs returned by the block to a Hash' do
      expect(%i[a b].to_h { |k| [k, k.to_s] }).to eql(a: 'a', b: 'b')
    end

    it 'raises ArgumentError if block returns longer or shorter array' do
      expect do
        %i[a b].to_h { |k| [k, k.to_s, 1] }
      end.to raise_error(ArgumentError, 'wrong array length at 0 (expected 2, was 3)')

      expect do
        %i[a b].to_h { |k| [k] }
      end.to raise_error(ArgumentError, 'wrong array length at 0 (expected 2, was 1)')
    end

    it 'raises TypeError if block returns something other than Array' do
      expect do
        %i[a b].to_h { |_| 'not-array' }
      end.to raise_error(TypeError, 'wrong element type String at 0 (expected array)')
    end

    it 'coerces returned pair to Array with #to_ary' do
      x = Class.new do
        def to_ary
          [:b, 'b']
        end
      end.new

      expect([:a].to_h { |_| x }).to eql(b: 'b')
    end

    it 'does not coerce returned pair to Array with #to_a' do
      x = Class.new do
        def to_a
          [:b, 'b']
        end
      end.new

      expect do
        [:a].to_h { |_| x }
      end.to raise_error(TypeError, /wrong element type .+ at 0/)
    end
  end
end
