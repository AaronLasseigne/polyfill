RSpec.describe 'Enumerable#one?' do
  using Polyfill(Enumerable: %w[#one?], version: '2.5')

  context 'existing behavior' do
    it 'works' do
      expect([0, 1, 2].one? { |x| x > 2 }).to be false
      expect([2, 3, 4].one? { |x| x > 2 }).to be false
      expect([1, 2, 3].one? { |x| x > 2 }).to be true
    end
  end

  context '2.5' do
    it 'when given an argument, the block is ignored' do
      expect([1, 'a'].one?(Integer) { |x| x > 2 }).to be true
    end

    it 'accepts a regexp' do
      expect(%w[abc def ghi].one?(/\A\d/)).to be false
      expect(%w[abc 4ef 7hi].one?(/\A\d/)).to be false
      expect(%w[abc 4ef ghi].one?(/\A\d/)).to be true
    end

    it 'accepts a Class' do
      expect(%w[abc def ghi].one?(Integer)).to be false
      expect([1, 2, 'ghi'].one?(Integer)).to be false
      expect([1, 'def', 'ghi'].one?(Integer)).to be true
    end

    it 'errors when too mone arguments are passed' do
      expect { [].one?(1, 2) }.to raise_error ArgumentError
    end
  end
end
