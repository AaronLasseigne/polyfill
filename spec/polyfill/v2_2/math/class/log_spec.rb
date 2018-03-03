RSpec.describe 'Math.log' do
  using Polyfill(Math: %w[.log], version: '2.2')

  let(:tolerance) { 0.00003 }

  context 'existing behavior' do
    it 'returns a float' do
      expect(Math.log(1)).to be_kind_of(Float)
    end

    it 'returns the natural logarithm of the argument' do
      expect(Math.log(0.0001)).to be_within(tolerance).of(-9.21034037197618)
      expect(Math.log(0.000000000001e-15)).to be_within(tolerance).of(-62.1697975108392)
      expect(Math.log(1)).to be_within(tolerance).of(0.0)
      expect(Math.log(10)).to be_within(tolerance).of(2.30258509299405)
      expect(Math.log(10e15)).to be_within(tolerance).of(36.8413614879047)
    end

    it 'raises a TypeError if the argument cannot be coerced with Float()' do
      expect { Math.log('test') }.to raise_error(TypeError)
    end

    it 'raises a TypeError for numerical values passed as string' do
      expect { Math.log('10') }.to raise_error(TypeError)
    end

    it 'accepts a second argument for the base' do
      expect(Math.log(9, 3)).to be_within(tolerance).of(2)
      expect(Math.log(8, 1.4142135623730951)).to be_within(tolerance).of(6)
    end

    it 'raises a TypeError when the numerical base cannot be coerced to a float' do
      expect { Math.log(10, '2') }.to raise_error(TypeError)
      expect { Math.log(10, nil) }.to raise_error(TypeError)
    end

    it 'returns NaN given NaN' do
      expect(Math.log(0 / 0.0).nan?).to be true
    end

    it 'raises a TypeError if the argument is nil' do
      expect { Math.log(nil) }.to raise_error(TypeError)
    end

    it 'accepts any argument that can be coerced with Float()' do
      value = Class.new(Numeric) do
        def to_f
          1.0
        end
      end.new

      expect(Math.log(value)).to be_within(tolerance).of(0.0)
    end
  end

  context '2.2' do
    it 'raises Math::DomainError if the base is less than 0' do
      expect { Math.log(12, -1) }.to raise_error(Math::DomainError, 'Numerical argument is out of domain - "log"')
    end

    it 'returns NaN if both argument are 0' do
      expect(Math.log(0, 0).nan?).to be true

      zero = Class.new(Numeric) do
        def to_f
          0.0
        end
      end.new
      expect(Math.log(zero, zero).nan?).to be true
    end
  end
end
