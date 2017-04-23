RSpec.describe 'Enumerable#chunk_while' do
  using Polyfill(Enumerable: %w[#chunk_while])

  let(:enum) { [10, 9, 7, 6, 4, 3, 2, 1] }
  let(:result) { enum.chunk_while { |i, j| i - 1 == j } }

  context 'when given a block' do
    it 'returns an enumerator' do
      expect(result).to be_an_instance_of(Enumerator)
    end

    it 'splits chunks between adjacent elements i and j where the block returns false' do
      expect(result.to_a).to eql [[10, 9], [7, 6], [4, 3, 2, 1]]

      enum = [10, 9, 7, 6, 4, 3, 2, 0]
      result = enum.chunk_while { |i, j| i - 1 == j }
      expect(result.to_a).to eql [[10, 9], [7, 6], [4, 3, 2], [0]]
    end

    it 'calls the block for length of the receiver enumerable minus one times' do
      times_called = 0
      enum.chunk_while do |a, b|
        times_called += 1
        a - 1 == b
      end.to_a
      expect(times_called).to eql(enum.length - 1)
    end
  end

  context 'when not given a block' do
    it 'raises an ArgumentError' do
      expect { enum.chunk_while }.to raise_error ArgumentError
    end
  end

  context 'on a single-element array' do
    it 'ignores the block and returns an enumerator that yields [element]' do
      expect([1].chunk_while(&:even?).to_a).to eql [[1]]
    end
  end

  context 'when an iterator method yields more than one value' do
    it 'processes all yielded values' do
      def foo
        yield 1, 2
        yield 3, 4
      end
      expect(to_enum(:foo).chunk_while { false }.to_a).to eql [[[1, 2]], [[3, 4]]]
    end
  end
end
