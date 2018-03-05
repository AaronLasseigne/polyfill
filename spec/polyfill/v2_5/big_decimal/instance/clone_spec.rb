require 'bigdecimal'

RSpec.describe 'BigDecimal#clone' do
  using Polyfill(BigDecimal: %w[#clone], version: '2.5')

  let(:decimal) { BigDecimal('0') }

  context 'existing behavior' do
    it 'returns an object of equal value' do
      expect(decimal.clone).to eql decimal
    end
  end

  context '2.5' do
    it 'returns the exact same object' do
      expect(decimal.clone.object_id).to eql decimal.object_id
    end
  end
end
