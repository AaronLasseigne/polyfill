require 'ipaddr'

RSpec.describe 'IPAddr#<=>' do
  using Polyfill(IPAddr: %w[#<=>], version: '2.4')

  context 'existing behavior' do
    it 'works' do
      expect(IPAddr.new('1.1.1.1') <=> '1.1.1.1').to eql 0
      expect(IPAddr.new('1.1.1.1') <=> '1.1.1.0').to eql 1
      expect(IPAddr.new('1.1.1.1') <=> '1.1.1.2').to eql(-1)
    end
  end

  context '2.4' do
    it 'does not throw an error when it cannot coerce the comparison' do
      expect { IPAddr.new('1.1.1.0') <=> 'invalid' }.to_not raise_error
      expect(IPAddr.new('1.1.1.0') <=> 'invalid').to be nil
    end
  end
end
