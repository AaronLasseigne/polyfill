RSpec.describe 'Kernel#Rational' do
  using Polyfill(Kernel: %w[#Rational], version: '2.6')

  context 'when passed exception: true' do
    it 'works' do
      rat = Rational(1, 2)
      expect(rat.numerator).to eql 1
      expect(rat.denominator).to eql 2
      expect(rat).to be_an_instance_of(Rational)

      rat = Rational(1, 2, exception: true)
      expect(rat.numerator).to eql 1
      expect(rat.denominator).to eql 2
      expect(rat).to be_an_instance_of(Rational)

      expect { Rational(1, nil, exception: true) }.to raise_error TypeError
      expect { Rational(1, nil) }.to raise_error TypeError

      expect { Object.new.Rational(1, 2) }.to raise_error NoMethodError
    end
  end

  context 'when passed exception: false' do
    context 'when passed exception: false' do
      context 'and [non-Numeric]' do
        it 'swallows an error' do
          expect(Rational(:sym, exception: false)).to be nil
          expect(Rational('abc', exception: false)).to be nil
        end
      end

      context 'and [non-Numeric, Numeric]' do
        it 'swallows an error' do
          expect(Rational(:sym, 1, exception: false)).to be nil
          expect(Rational('abc', 1, exception: false)).to be nil
        end
      end

      context 'and [anything, non-Numeric]' do
        it 'swallows an error' do
          expect(Rational(:sym, :sym, exception: false)).to be nil
          expect(Rational('abc', :sym, exception: false)).to be nil
        end
      end

      context 'and non-Numeric String arguments' do
        it 'swallows an error' do
          expect(Rational('a', 'b', exception: false)).to be nil
          expect(Rational('a', 0, exception: false)).to be nil
          expect(Rational(0, 'b', exception: false)).to be nil
        end
      end

      context 'and nil arguments' do
        it 'swallows an error' do
          expect(Rational(nil, exception: false)).to be nil
          expect(Rational(nil, nil, exception: false)).to be nil
        end
      end
    end
  end
end
