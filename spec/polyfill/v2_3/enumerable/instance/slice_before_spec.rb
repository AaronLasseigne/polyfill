RSpec.describe 'Enumerable#slice_before' do
  using Polyfill(Enumerable: %w[#slice_before])

  context 'existing behavior' do
    it 'works' do
      expect(
        (1..7).to_a.slice_before(->(n) { n % 3 == 0 }).to_a
      ).to eql [[1, 2], [3, 4, 5], [6, 7]]
      expect(
        (1..7).to_a.slice_before { |n| n % 3 == 0 }.to_a
      ).to eql [[1, 2], [3, 4, 5], [6, 7]]
    end
  end

  context '2.3' do
    it 'no longer accepts an initial state' do
      expect do
        [].slice_before(0) { |_n, _init| true }
      end.to raise_error(ArgumentError, 'wrong number of arguments (given 1, expected 0)')
    end
  end
end
