RSpec.describe 'OpenStruct#to_h' do
  using Polyfill(OpenStruct: %w[#to_h], version: '2.6')

  let(:h) do
    { name: 'John Smith', age: 70, pension: 300 }
  end
  let(:os) { OpenStruct.new(h) }

  it 'returns a hash' do
    expect(os.to_h).to eql(name: 'John Smith', age: 70, pension: 300)
  end

  context 'with block' do
    it 'converts [key, value] pairs returned by the block to a hash' do
      h = os.to_h { |k, v| [k.to_s, v * 2] }
      expect(h).to eql('name' => 'John SmithJohn Smith', 'age' => 140, 'pension' => 600)
    end

    it 'raises ArgumentError if block returns longer or shorter array' do
      expect do
        os.to_h { |k, v| [k.to_s, v * 2, 1] }
      end.to raise_error(ArgumentError, 'element has wrong array length (expected 2, was 3)')

      expect do
        os.to_h { |k, _| [k] }
      end.to raise_error(ArgumentError, 'element has wrong array length (expected 2, was 1)')
    end

    it 'raises TypeError if block returns something other than Array' do
      expect do
        os.to_h { |_, _| 'not-array' }
      end.to raise_error(TypeError, 'wrong element type String (expected array)')
    end

    it 'coerces returned pair to Array with #to_ary' do
      x = Class.new do
        def to_ary
          [:b, 'b']
        end
      end.new

      expect(os.to_h { |_| x }).to eql(b: 'b')
    end

    it 'does not coerce returned pair to Array with #to_a' do
      x = Class.new do
        def to_a
          [:b, 'b']
        end
      end.new

      expect do
        os.to_h { |_| x }
      end.to raise_error(TypeError, /\Awrong element type #<Class:.+?> \(expected array\)\z/)
    end
  end
end
