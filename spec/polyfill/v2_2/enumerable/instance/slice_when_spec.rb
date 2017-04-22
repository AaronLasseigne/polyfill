RSpec.describe 'Enumerable#slice_when' do
  using Polyfill(Enumerable: %w[#slice_when])

  let(:enum) { [10, 9, 7, 6, 4, 3, 2, 1] }
  let(:result) { enum.slice_when { |i, j| i - 1 != j } }

  context 'when given a block' do
    it 'returns an enumerator' do
      expect(result).to be_an_instance_of(Enumerator)
    end

    it 'splits chunks between adjacent elements i and j where the block returns true' do
      expect(result.to_a).to eql [[10, 9], [7, 6], [4, 3, 2, 1]]
    end

    it 'calls the block for length of the receiver enumerable minus one times' do
      times_called = 0
      enum.slice_when do |i, j|
        times_called += 1
        i - 1 != j
      end.to_a
      expect(times_called).to eql(enum.length - 1)
    end

    it "doesn't yield an empty array if the block matches the first or the last time" do
      expect(enum.slice_when { true }.to_a).to eql [[10], [9], [7], [6], [4], [3], [2], [1]]
    end

    it "doesn't yield an empty array on a small enumerable" do
      expect([].slice_when { raise }.to_a).to eql []
      expect([42].slice_when { raise }.to_a).to eql [[42]]
    end
  end

  context 'when not given a block' do
    it 'raises an ArgumentError' do
      expect { enum.slice_when }.to raise_error(ArgumentError, 'tried to create Proc object without a block')
    end
  end

  context 'when an iterator method yields more than one value' do
    it 'processes all yielded values' do
      def foo
        yield 1, 2
        yield 3, 4
      end
      expect(to_enum(:foo).slice_when { true }.to_a).to eql [[[1, 2]], [[3, 4]]]
    end
  end
end
