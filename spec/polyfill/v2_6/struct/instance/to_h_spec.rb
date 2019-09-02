RSpec.describe 'Struct#to_h' do
  using Polyfill(Struct: %w[#to_h], version: '2.6')

  let(:struct_car) do
    Struct.new(:make, :model, :year)
  end

  it 'allows no arguments' do
    car = struct_car.new('Ford', 'Ranger')

    expect(car.to_h).to eql(make: 'Ford', model: 'Ranger', year: nil)
  end

  context 'with block' do
    it 'converts [key, value] pairs returned by the block to a hash' do
      car = struct_car.new('Ford', 'Ranger')

      h = car.to_h { |k, v| [k.to_s, v.to_s.downcase] }
      expect(h).to eql('make' => 'ford', 'model' => 'ranger', 'year' => '')
    end

    it 'raises ArgumentError if block returns longer or shorter array' do
      expect do
        struct_car.new.to_h { |k, v| [k.to_s, v.to_s.downcase, 1] }
      end.to raise_error(ArgumentError, 'element has wrong array length (expected 2, was 3)')

      expect do
        struct_car.new.to_h { |k, _| [k] }
      end.to raise_error(ArgumentError, 'element has wrong array length (expected 2, was 1)')
    end

    it 'raises TypeError if block returns something other than Array' do
      expect do
        struct_car.new.to_h { |_, _| 'not-array' }
      end.to raise_error(TypeError, 'wrong element type String (expected array)')
    end

    it 'coerces returned pair to Array with #to_ary' do
      x = Class.new do
        def to_ary
          [:b, 'b']
        end
      end.new

      expect(struct_car.new.to_h { |_| x }).to eql(b: 'b')
    end

    it 'does not coerce returned pair to Array with #to_a' do
      x = Class.new do
        def to_a
          [:b, 'b']
        end
      end.new

      expect do
        struct_car.new.to_h { |_| x }
      end.to raise_error(TypeError, /\Awrong element type #<Class:.+?> \(expected array\)\z/)
    end
  end
end
