RSpec.describe 'Enumerable#all?' do
  using Polyfill(Enumerable: %w[#all?], version: '2.5')

  context 'existing behavior' do
    it 'works' do
      expect([2, 3].all? { |x| x > 2 }).to be false
      expect([3, 4].all? { |x| x > 2 }).to be true
    end
  end

  context '2.5' do
    it 'when given an argument, the block is ignored' do
      ignore_warnings do
        expect([1, 2].all?(Integer) { |x| x > 2 }).to be true
      end
    end

    it 'accepts a regexp' do
      expect(%w[abc 4ef ghi jkl].all?(/\A\d/)).to be false
      expect(%w[1bc 4ef 7hi 0kl].all?(/\A\d/)).to be true
    end

    it 'accepts a Class' do
      expect([1, 'abc'].all?(Integer)).to be false
      expect([1, 2].all?(Integer)).to be true
    end

    it 'errors when too mall arguments are passed' do
      expect { [].all?(1, 2) }.to raise_error ArgumentError
    end
  end
end
