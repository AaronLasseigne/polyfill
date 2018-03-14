RSpec.describe 'Enumerable#none?' do
  using Polyfill(Enumerable: %w[#none?], version: '2.5')

  context 'existing behavior' do
    it 'works' do
      expect([2, 3].none? { |x| x > 2 }).to be false
      expect([1, 2].none? { |x| x > 2 }).to be true
    end
  end

  context '2.5' do
    it 'when given an argument, the block is ignored' do
      expect([2, 3].none?(String) { |x| x > 2 }).to be true
    end

    it 'accepts a regexp' do
      expect(%w[abc 4ef 7hi jkl].none?(/\A\d/)).to be false
      expect(%w[abc def ghi jkl].none?(/\A\d/)).to be true
    end

    it 'accepts a Class' do
      expect([1, 'abc'].none?(String)).to be false
      expect([1, 2].none?(String)).to be true
    end

    it 'errors when too mnone arguments are passed' do
      expect { [].none?(1, 2) }.to raise_error ArgumentError
    end
  end
end
