RSpec.describe 'Numeric#clone' do
  using Polyfill(Numeric: %w[#clone], version: '2.4')

  it 'does not throw an error' do
    # on 2.4 this is crashing Ruby which is why it's now wrapped
    when_ruby_below '2.4' do
      expect { 1.clone }.to_not raise_error
      expect { 1.clone(freeze: true) }.to_not raise_error
    end
  end
end
