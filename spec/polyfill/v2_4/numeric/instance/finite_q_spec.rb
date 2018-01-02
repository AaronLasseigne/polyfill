RSpec.describe 'Numeric#finite?' do
  using Polyfill(Numeric: %w[#finite?], version: '2.4')

  it 'returns true if a number is finite' do
    expect(1.finite?).to be true
    expect(1i.finite?).to be true
    expect(Rational(1).finite?).to be true
  end
end
