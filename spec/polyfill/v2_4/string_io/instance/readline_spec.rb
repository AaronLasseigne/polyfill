RSpec.describe 'StringIO#readline' do
  using Polyfill(StringIO: %w[#readline])

  let(:io) { StringIO.new("line 1\nline 2\n") }

  context 'existing behavior' do
    it 'works' do
      expect(io.readline).to eql "line 1\n"
    end
  end

  context '2.4' do
    context 'chomp flag' do
      it 'chomps the line when true' do
        expect(io.readline(chomp: true)).to eql 'line 1'
      end

      it 'chomps when the limit is set and chomp is true' do
        expect(io.readline(7, chomp: true)).to eql 'line 1'
      end

      it 'chomps when the separator is changed and chomp is true' do
        expect(io.readline(' ', chomp: true)).to eql 'line'
      end

      it 'accepts implicit strings' do
        obj = double('string')
        allow(obj).to receive(:to_str).and_return(' ')
        expect(io.readline(obj, chomp: true)).to eql 'line'
      end

      it 'chomps when the separator is changed and the limit is set and chomp is true' do
        expect(io.readline(' ', 5, chomp: true)).to eql 'line'
      end

      it 'does not chomp the line when false' do
        expect(io.readline(chomp: false)).to eql "line 1\n"
      end

      it 'does not chomp when the limit is set and chomp is false' do
        expect(io.readline(7, chomp: false)).to eql "line 1\n"
      end

      it 'does not chomp when the separator is changed and chomp is false' do
        expect(io.readline(' ', chomp: false)).to eql 'line '
      end

      it 'does not chomp when the separator is changed and the limit is set and chomp is false' do
        expect(io.readline(' ', 5, chomp: false)).to eql 'line '
      end

      it 'returns nil to end the file' do
        io.readline(chomp: true)
        io.readline(chomp: true)
        expect { io.readline(chomp: true) }.to raise_error(EOFError, 'end of file reached')
      end
    end
  end
end
