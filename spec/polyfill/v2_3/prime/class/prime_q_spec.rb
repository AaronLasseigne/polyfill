require 'prime'

RSpec.describe 'Prime.prime?' do
  using Polyfill(Prime: %w[.prime?], version: '2.3')

  context 'existing behavior' do
  end

  context '2.3' do
    it 'checks that the argument is an integer' do
      expect { Prime.prime?('a') }.to raise_error(ArgumentError, 'Expected an integer, got a')
    end
  end
end
