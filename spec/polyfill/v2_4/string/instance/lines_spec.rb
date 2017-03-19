RSpec.describe 'String#lines' do
  using Polyfill(String: %w[#lines])

  let(:str) { "line 1\nline 2\n" }

  context 'existing behavior' do
    it 'works' do
      expect(str.lines).to eql ["line 1\n", "line 2\n"]
    end

    it 'works with a block' do
      orig = $VERBOSE
      $VERBOSE = nil

      acc = []
      expect(str.lines { |line| acc << line }).to be str
      expect(acc).to eql ["line 1\n", "line 2\n"]

      $VERBOSE = orig
    end
  end

  context '2.4' do
    context 'chomp flag' do
      it 'chomps the lines when true' do
        expect(str.lines(chomp: true)).to eql ['line 1', 'line 2']
      end

      it 'chomps when the separator is changed and chomp is true' do
        expect(str.lines(' ', chomp: true)).to eql ['line', "1\nline", "2\n"]
      end

      it 'accepts implicit strings' do
        obj = double('string')
        allow(obj).to receive(:to_str).and_return(' ')
        expect(str.lines(obj, chomp: true)).to eql ['line', "1\nline", "2\n"]
      end

      it 'does not chomp the lines when false' do
        expect(str.lines(chomp: false)).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the separator is changed and chomp is false' do
        expect(str.lines(' ', chomp: false)).to eql ['line ', "1\nline ", "2\n"]
      end
    end
  end
end
