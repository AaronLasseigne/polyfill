RSpec.describe 'Time.at' do
  using Polyfill(Time: %w[.at], version: '2.5')

  context 'existing behavior' do
    context 'passed Numeric' do
      it 'returns a Time object representing the given number of Integer seconds since 1970-01-01 00:00:00 UTC' do
        expect(Time.at(1_184_027_924).getgm.asctime).to eql 'Tue Jul 10 00:38:44 2007'
      end

      it 'returns a Time object representing the given number of Float seconds since 1970-01-01 00:00:00 UTC' do
        t = Time.at(10.5)

        expect(t.usec).to eql 500_000
        expect(t).to_not eql Time.at(10)
      end

      it 'returns a non-UTC Time' do
        expect(Time.at(1_184_027_924).utc?).to be false
      end

      it 'returns a subclass instance on a Time subclass' do
        c = Class.new(Time)
        t = c.at(0)

        expect(t).to be_an_instance_of(c)
      end

      it 'roundtrips a Rational produced by #to_r' do
        t = Time.now
        t2 = Time.at(t.to_r)

        expect(t2).to eql t
        expect(t2.usec).to eql t.usec
        expect(t2.nsec).to eql t.nsec
      end

      context 'passed BigDecimal' do
        it "doesn't round input value" do
          require 'bigdecimal'
          expect(Time.at(BigDecimal('1.1')).to_f).to eql 1.1
        end
      end
    end

    context 'passed Time' do
      it 'creates a new time object with the value given by time' do
        t = Time.now

        expect(Time.at(t).inspect).to eql t.inspect
      end

      it 'creates a dup time object with the value given by time' do
        t1 = Time.new
        t2 = Time.at(t1)

        expect(t1).to_not equal t2
      end

      it 'returns a UTC time if the argument is UTC' do
        t = Time.now.getgm

        expect(Time.at(t).utc?).to be true
      end

      it 'returns a non-UTC time if the argument is non-UTC' do
        t = Time.now

        expect(Time.at(t).utc?).to be false
      end

      it 'returns a subclass instance' do
        c = Class.new(Time)
        t = c.at(Time.now)

        expect(t).to be_an_instance_of(c)
      end
    end

    context 'passed non-Time, non-Numeric' do
      it 'raises a TypeError with a String argument' do
        expect { Time.at('0') }.to raise_error(TypeError)
      end

      it 'raises a TypeError with a nil argument' do
        expect { Time.at(nil) }.to raise_error(TypeError)
      end

      context 'with an argument that responds to #to_int' do
        it 'coerces using #to_int' do
          o = double('integer')
          expect(o).to receive(:to_int).and_return(0)

          expect(Time.at(o)).to eql Time.at(0)
        end
      end

      context 'with an argument that responds to #to_r' do
        it 'coerces using #to_r' do
          o = Class.new(Numeric) do
            def to_r
              Rational(5, 2)
            end
          end.new

          expect(Time.at(o)).to eql Time.at(Rational(5, 2))
        end
      end
    end

    context 'passed [Integer, Numeric]' do
      it 'returns a Time object representing the given number of seconds and Integer microseconds since 1970-01-01 00:00:00 UTC' do
        t = Time.at(10, 500_000)

        expect(t.tv_sec).to eql 10
        expect(t.tv_usec).to eql 500_000
      end

      it 'returns a Time object representing the given number of seconds and Float microseconds since 1970-01-01 00:00:00 UTC' do
        t = Time.at(10, 500.500)

        expect(t.tv_sec).to eql 10
        expect(t.tv_nsec).to eql 500_500
      end
    end

    context 'with a second argument that responds to #to_int' do
      it 'coerces using #to_int' do
        o = double('integer')
        expect(o).to receive(:to_int).and_return(10)

        expect(Time.at(0, o)).to eql Time.at(0, 10)
      end
    end

    context 'with a second argument that responds to #to_r' do
      it 'coerces using #to_r' do
        o = Class.new(Numeric) do
          def to_r
            Rational(5, 2)
          end
        end.new

        expect(Time.at(0, o)).to eql Time.at(0, Rational(5, 2))
      end
    end

    context 'passed [Integer, nil]' do
      it 'raises a TypeError' do
        expect { Time.at(0, nil) }.to raise_error(TypeError)
      end
    end

    context 'passed [Integer, String]' do
      it 'raises a TypeError' do
        expect { Time.at(0, '0') }.to raise_error(TypeError)
      end
    end

    context 'passed [Time, Integer]' do
      it 'raises a TypeError' do
        expect { Time.at(Time.now, 500_000) }.to raise_error(TypeError)
      end
    end
  end

  context '2.5' do
    context 'passed [Time, Numeric, format]' do
      context ':nanosecond format' do
        it 'traits second argument as nanoseconds' do
          expect(Time.at(0, 123_456_789, :nanosecond).nsec).to eql 123_456_789
        end
      end

      context ':nsec format' do
        it 'traits second argument as nanoseconds' do
          expect(Time.at(0, 123_456_789, :nsec).nsec).to eql 123_456_789
        end
      end

      context ':microsecond format' do
        it 'traits second argument as microseconds' do
          expect(Time.at(0, 123_456, :microsecond).nsec).to eql 123_456_000
        end
      end

      context ':usec format' do
        it 'traits second argument as microseconds' do
          expect(Time.at(0, 123_456, :usec).nsec).to eql 123_456_000
        end
      end

      context ':millisecond format' do
        it 'traits second argument as milliseconds' do
          expect(Time.at(0, 123, :millisecond).nsec).to eql 123_000_000
          expect(Time.at(0, 129.95, :millisecond).nsec).to eql 129_949_999 # FP Math
        end
      end

      context 'not supported format' do
        it 'raises ArgumentError' do
          expect { Time.at(0, 123_456, 2) }.to raise_error(ArgumentError)
          expect { Time.at(0, 123_456, nil) }.to raise_error(ArgumentError)
          expect { Time.at(0, 123_456, :invalid) }.to raise_error(ArgumentError)
        end

        it 'does not try to convert format to Symbol with #to_sym' do
          format = 'usec'
          expect(format).to_not receive(:to_sym)

          expect { Time.at(0, 123_456, format) }.to raise_error(ArgumentError)
        end
      end

      it 'supports Float second argument' do
        expect(Time.at(0, 123_456_789.500, :nanosecond).nsec).to eql 123_456_789
        expect(Time.at(0, 123_456_789.500, :nsec).nsec).to eql 123_456_789
        expect(Time.at(0, 123_456.500, :microsecond).nsec).to eql 123_456_500
        expect(Time.at(0, 123_456.500, :usec).nsec).to eql 123_456_500
        expect(Time.at(0, 123.500, :millisecond).nsec).to eql 123_500_000
      end
    end
  end
end
