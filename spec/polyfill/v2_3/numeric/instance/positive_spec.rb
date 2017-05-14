RSpec.describe 'Numeric#positive?' do
  using Polyfill(Numeric: %w[#positive?])

  context 'on positive numbers' do
    it 'returns true' do
      expect(1.positive?).to be true
      expect(0.1.positive?).to be true
    end
  end

  context 'on zero' do
    it 'returns false' do
      expect(0.positive?).to be false
      expect(0.0.positive?).to be false
    end
  end

  context 'on positive numbers' do
    it 'returns true' do
      expect(-1.positive?).to be false
      expect(-0.1.positive?).to be false
    end
  end

  context 'subclasses' do
    let(:obj) do
      Class.new(Numeric) do
        def singleton_method_added(val)
          # allows singleton methods to be mocked (i.e. :>)
        end
      end.new
    end

    it 'returns true if self is less than 0' do
      allow(obj).to receive(:>).with(0).and_return(true)

      expect(obj.positive?).to be true
    end

    it 'returns false if self is greater than 0' do
      allow(obj).to receive(:>).with(0).and_return(false)

      expect(obj.positive?).to be false
    end
  end
end
