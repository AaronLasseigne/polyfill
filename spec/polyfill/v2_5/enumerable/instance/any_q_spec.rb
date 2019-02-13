RSpec.describe 'Enumerable#any?' do
  using Polyfill(Enumerable: %w[#any?], version: '2.5')

  context 'existing behavior' do
    it 'works' do
      expect([1, 2].any? { |x| x > 2 }).to be false
      expect([2, 3].any? { |x| x > 2 }).to be true
    end
  end

  context '2.5' do
    it 'when given an argument, the block is ignored' do
      ignore_warnings do
        expect([1, 2].any?(Integer) { |x| x > 2 }).to be true
      end
    end

    it 'accepts a regexp' do
      expect(%w[abc def ghi jkl].any?(/\A\d/)).to be false
      expect(%w[abc 4ef 7hi jkl].any?(/\A\d/)).to be true
    end

    it 'accepts a Class' do
      expect(%w[abc def].any?(Integer)).to be false
      expect([1, 'abc'].any?(Integer)).to be true
    end

    it 'errors when too many arguments are passed' do
      expect { [].any?(1, 2) }.to raise_error ArgumentError
    end
  end
end
