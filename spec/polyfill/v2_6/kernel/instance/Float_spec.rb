RSpec.describe 'Kernel#Float' do
  using Polyfill(Kernel: %w[#Float], version: '2.6')

  context 'when passed exception: true' do
    it 'works' do
      expect(Float(1)).to eql 1.0
      expect(Float(1, exception: true)).to eql 1.0

      expect { Float('abc', exception: true) }.to raise_error ArgumentError
      expect { Float('abc') }.to raise_error ArgumentError

      expect { Object.new.Float(1) }.to raise_error NoMethodError
    end
  end

  context 'when passed exception: false' do
    context 'and valid input' do
      it 'returns a Float number' do
        expect(Float(1, exception: false)).to eql 1.0
        expect(Float('1', exception: false)).to eql 1.0
        expect(Float('1.23', exception: false)).to eql 1.23
      end
    end

    context 'and invalid input' do
      it 'swallows an error' do
        expect(Float('abc', exception: false)).to be nil
        expect(Float(:sym, exception: false)).to be nil
      end
    end

    context 'and nil' do
      it 'swallows it' do
        expect(Float(nil, exception: false)).to be nil
      end
    end
  end
end
