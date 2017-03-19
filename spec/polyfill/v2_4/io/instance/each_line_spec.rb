RSpec.describe 'IO#each_line' do
  using Polyfill(IO: %w[#each_line])

  def fixture(file_name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  let(:file_name) { fixture('file.txt') }
  let(:io) { IO.new(IO.sysopen(file_name)) }
  let(:acc) { [] }

  context 'existing behavior' do
    it 'works' do
      expect(io.each_line { |line| acc << line }).to be io
      expect(acc).to eql ["line 1\n", "line 2\n"]
    end

    it 'works without a block' do
      expect(io.each_line).to be_an Enumerator
      io.each_line.with_index { |line, i| acc << "#{i} #{line}" }
      expect(acc).to eql ["0 line 1\n", "1 line 2\n"]
    end
  end

  context '2.4' do
    context 'chomp flag' do
      it 'returns an Enumerator when no block is given' do
        expect(io.each_line(chomp: true)).to be_an Enumerator
        io.each_line(chomp: true).with_index { |line, i| acc << "#{i} #{line}" }
        expect(acc).to eql ['0 line 1', '1 line 2']
      end

      it 'chomps the lines when true' do
        expect(io.each_line(chomp: true) { |line| acc << line }).to be io
        expect(acc).to eql ['line 1', 'line 2']
      end

      it 'chomps when the limit is set and chomp is true' do
        io.each_line(7, chomp: true) { |line| acc << line }
        expect(acc).to eql ['line 1', 'line 2']
      end

      it 'chomps when the separator is changed and chomp is true' do
        io.each_line(' ', chomp: true) { |line| acc << line }
        expect(acc).to eql ['line', "1\nline", "2\n"]
      end

      it 'accepts implicit strings' do
        obj = double('string')
        allow(obj).to receive(:to_str).and_return(' ')
        io.each_line(obj, chomp: true) { |line| acc << line }
        expect(acc).to eql ['line', "1\nline", "2\n"]
      end

      it 'chomps when the separator is changed and the limit is set and chomp is true' do
        io.each_line(' ', 5, chomp: true) { |line| acc << line }
        expect(acc).to eql ['line', "1\nlin", 'e', "2\n"]
      end

      it 'does not chomp the lines when false' do
        io.each_line(chomp: false) { |line| acc << line }
        expect(acc).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the limit is set and chomp is false' do
        io.each_line(7, chomp: false) { |line| acc << line }
        expect(acc).to eql ["line 1\n", "line 2\n"]
      end

      it 'does not chomp when the separator is changed and chomp is false' do
        io.each_line(' ', chomp: false) { |line| acc << line }
        expect(acc).to eql ['line ', "1\nline ", "2\n"]
      end

      it 'does not chomp when the separator is changed and the limit is set and chomp is false' do
        io.each_line(' ', 5, chomp: false) { |line| acc << line }
        expect(acc).to eql ['line ', "1\nlin", 'e ', "2\n"]
      end
    end
  end
end
