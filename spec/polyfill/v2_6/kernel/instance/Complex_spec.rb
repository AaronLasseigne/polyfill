RSpec.describe 'Kernel#Complex' do
  using Polyfill(Kernel: %w[#Complex], version: '2.6')

  context 'when passed exception: true' do
    it 'works' do
      expect(Complex(1, 2)).to be_an_instance_of(Complex)
      expect(Complex(1, 2).real).to eql 1
      expect(Complex(1, 2).imag).to eql 2
      expect(Complex(1, 2, exception: true)).to be_an_instance_of(Complex)
      expect(Complex(1, 2, exception: true).real).to eql 1
      expect(Complex(1, 2, exception: true).imag).to eql 2

      expect { Complex('a', 'b') }.to raise_error ArgumentError
      expect { Complex('a', 'b', exception: true) }.to raise_error ArgumentError

      expect { Object.new.Complex(1, 1) }.to raise_error NoMethodError
    end
  end

  context 'when passed exception: false' do
    context 'and [Numeric]' do
      it 'returns a complex number' do
        expect(Complex('123', exception: false)).to eql Complex(123)
      end
    end

    context 'and [non-Numeric]' do
      it 'swallows an error' do
        expect(Complex(:sym, exception: false)).to be nil
      end
    end

    context 'and [non-Numeric, Numeric] argument' do
      it 'throws a TypeError' do
        expect { Complex(:sym, 0, exception: false) }.to raise_error(TypeError, 'not a real')
      end
    end

    context 'and [anything, non-Numeric] argument' do
      it 'swallows an error' do
        expect(Complex('a',  :sym, exception: false)).to be nil
        expect(Complex(:sym, :sym, exception: false)).to be nil
        expect(Complex(0,    :sym, exception: false)).to be nil
      end
    end

    context 'and non-numeric String arguments' do
      it 'swallows an error' do
        expect(Complex('a', 'b', exception: false)).to be nil
        expect(Complex('a', 0, exception: false)).to be nil
        expect(Complex(0, 'b', exception: false)).to be nil
      end
    end

    context 'and nil arguments' do
      it 'swallows an error' do
        expect(Complex(nil, exception: false)).to be nil
        expect(Complex(0, nil, exception: false)).to be nil
        expect(Complex(nil, 0, exception: false)).to be nil
      end
    end
  end
end
