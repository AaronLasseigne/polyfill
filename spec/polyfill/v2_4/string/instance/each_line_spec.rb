RSpec.describe 'String#each_line' do
  using Polyfill(String: %w[#each_line])

  let(:str) { "line 1\nline 2\n" }
  let(:acc) { [] }

  context 'existing behavior' do
    it 'works' do
      expect(str.each_line { |line| acc << line }).to be str
      expect(acc).to eql ["line 1\n", "line 2\n"]
    end

    it 'works without a block' do
      expect(str.each_line).to be_an Enumerator
      str.each_line.with_index { |line, i| acc << "#{i} #{line}" }
      expect(acc).to eql ["0 line 1\n", "1 line 2\n"]
    end
  end

  context '2.4' do
    context 'chomp flag' do
      it 'returns an Enumerator when no block is given' do
        expect(str.each_line(chomp: true)).to be_an Enumerator
        str.each_line(chomp: true).with_index { |line, i| acc << "#{i} #{line}" }
        expect(acc).to eql ['0 line 1', '1 line 2']
      end

      it 'chomps the lines when true' do
        expect(str.each_line(chomp: true) { |line| acc << line }).to be str
        expect(acc).to eql ['line 1', 'line 2']
      end

      it 'chomps when the separator is changed and chomp is true' do
        str.each_line(' ', chomp: true) { |line| acc << line }
        expect(acc).to eql %W[line 1\nline 2\n]
      end

      it 'accepts implicit strings' do
        obj = double('string')
        allow(obj).to receive(:to_str).and_return(' ')
        str.each_line(obj, chomp: true) { |line| acc << line }
        expect(acc).to eql %W[line 1\nline 2\n]
      end

      it 'does not chomp the lines when false' do
        str.each_line(chomp: false) { |line| acc << line }
        expect(acc).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the separator is changed and chomp is false' do
        str.each_line(' ', chomp: false) { |line| acc << line }
        expect(acc).to eql ['line ', "1\nline ", "2\n"]
      end
    end
  end
end
