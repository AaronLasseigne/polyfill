RSpec.describe 'StringIO#readlines' do
  using Polyfill(StringIO: %w[#readlines])

  let(:io) { StringIO.new("line 1\nline 2\n") }

  context 'existing behavior' do
    it 'works' do
      expect(io.readlines).to eql ["line 1\n", "line 2\n"]
    end
  end

  context '2.4' do
    context 'chomp flag' do
      it 'chomps the lines when true' do
        expect(io.readlines(chomp: true)).to eql ['line 1', 'line 2']
      end

      it 'chomps when the limit is set and chomp is true' do
        expect(io.readlines(7, chomp: true)).to eql ['line 1', 'line 2']
      end

      it 'chomps when the separator is changed and chomp is true' do
        expect(io.readlines(' ', chomp: true)).to eql %W[line 1\nline 2\n]
      end

      it 'accepts implicit strings' do
        obj = double('string')
        allow(obj).to receive(:to_str).and_return(' ')
        expect(io.readlines(obj, chomp: true)).to eql %W[line 1\nline 2\n]
      end

      it 'chomps when the separator is changed and the limit is set and chomp is true' do
        expect(io.readlines(' ', 5, chomp: true)).to eql %W[line 1\nlin e 2\n]
      end

      it 'does not chomp the lines when false' do
        expect(io.readlines(chomp: false)).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the limit is set and chomp is false' do
        expect(io.readlines(7, chomp: false)).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the separator is changed and chomp is false' do
        expect(io.readlines(' ', chomp: false)).to eql ['line ', "1\nline ", "2\n"]
      end

      it 'does not chomp when the separator is changed and the limit is set and chomp is false' do
        expect(io.readlines(' ', 5, chomp: false)).to eql ['line ', "1\nlin", 'e ', "2\n"]
      end
    end
  end
end
