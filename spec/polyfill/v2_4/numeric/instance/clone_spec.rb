RSpec.describe 'Numeric#clone' do
  using Polyfill(Numeric: %w[#clone])

  it 'does not throw an error' do
    expect { 1.clone }.to_not raise_error
    expect { 1.clone(freeze: true) }.to_not raise_error
  end
end
