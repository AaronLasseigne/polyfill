RSpec.describe 'Enumerable#grep_v' do
  using Polyfill(Enumerable: %w[#grep_v], version: '2.3')

  let(:numerous) { (0..9).to_a }
  let(:odd_matcher) do
    def (odd_matcher = BasicObject.new).===(obj)
      obj.odd?
    end
    odd_matcher
  end

  describe 'without block' do
    it 'returns an Array of matched elements' do
      expect(numerous.grep_v(odd_matcher)).to eql [0, 2, 4, 6, 8]
      expect(
        { one: 1, two: 2 }.grep_v(->((_, v)) { v.odd? })
      ).to eql [[:two, 2]]
    end

    it 'compares pattern with gathered array when yielded with multiple arguments' do
      expect(unmatcher = Object.new).to receive(:===).exactly(10).times

      numerous.grep_v(unmatcher)
    end

    it 'raises an ArgumentError when not given a pattern' do
      expect { numerous.grep_v }.to raise_error(ArgumentError)
    end
  end

  describe 'with block' do
    it 'returns an Array of matched elements that mapped by the block' do
      expect(numerous.grep_v(odd_matcher) { |n| n * 2 }).to eql [0, 4, 8, 12, 16]
    end

    it 'calls the block with gathered array when yielded with multiple arguments' do
      expect(unmatcher = Object.new).to receive(:===).exactly(10).times

      numerous.grep_v(unmatcher) { |e| e }
    end

    it 'raises an ArgumentError when not given a pattern' do
      expect { numerous.grep_v { |e| e } }.to raise_error(ArgumentError)
    end
  end
end
