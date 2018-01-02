require 'ipaddr'

RSpec.describe 'IPAddr#==' do
  using Polyfill(IPAddr: %w[#==], version: '2.4')

  context 'existing behavior' do
    it 'works' do
      expect(IPAddr.new('1.1.1.0') == '1.1.1.0').to be true
      expect(IPAddr.new('1.1.1.0') == '2.1.1.0').to be false
    end
  end

  context '2.4' do
    it 'does not throw an error when it cannot coerce the comparison' do
      expect { IPAddr.new('1.1.1.0') == 'invalid' }.to_not raise_error
      expect(IPAddr.new('1.1.1.0') == 'invalid').to be false
    end
  end
end
