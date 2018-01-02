RSpec.describe 'Numeric#dup' do
  using Polyfill(Numeric: %w[#dup], version: '2.4')

  it 'does not throw an error' do
    expect { 1.dup }.to_not raise_error
  end
end
