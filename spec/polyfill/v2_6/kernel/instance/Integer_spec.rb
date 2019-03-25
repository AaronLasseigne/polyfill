RSpec.describe 'Kernel#Integer' do
  using Polyfill(Kernel: %w[#Integer], version: '2.6')

  context 'when passed exception: true' do
    it 'works' do
      expect(Integer(1)).to eql 1
      expect(Integer(1, exception: true)).to eql 1

      expect { Integer('abc', exception: true) }.to raise_error ArgumentError
      expect { Integer('abc') }.to raise_error ArgumentError

      expect { Object.new.Integer(1) }.to raise_error NoMethodError
    end
  end

  context 'when passed exception: false' do
    context 'and to_i returns a value that is not an Integer' do
      it 'swallows an error' do
        obj = Class.new do
          def to_i
            '1'
          end
        end.new

        expect(Integer(obj, exception: false)).to be nil
      end
    end

    context 'and no to_int or to_i methods exist' do
      it 'swallows an error' do
        expect(Integer(Object.new, exception: false)).to be nil
      end
    end

    context 'and to_int returns nil and no to_i exists' do
      it 'swallows an error' do
        obj = Class.new do
          def to_i
            nil
          end
        end.new

        expect(Integer(obj, exception: false)).to be nil
      end
    end

    context 'and passed NaN' do
      it 'swallows an error' do
        expect(Integer(0 / 0.0, exception: false)).to be nil
      end
    end

    context 'and passed Infinity' do
      it 'swallows an error' do
        expect(Integer(Float::INFINITY, exception: false)).to be nil
      end
    end

    context 'and passed nil' do
      it 'swallows an error' do
        expect(Integer(nil, exception: false)).to be nil
      end
    end

    context 'and passed a String that contains numbers' do
      it 'normally parses it and returns an Integer' do
        expect(Integer('42', exception: false)).to be 42
      end
    end

    context "and passed a String that can't be converted to an Integer" do
      it 'swallows an error' do
        expect(Integer('abc', exception: false)).to be nil
      end
    end
  end
end
