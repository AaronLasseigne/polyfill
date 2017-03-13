RSpec.describe 'Numeric#finite?' do
  using Polyfill::V2_4::Numeric::Finite__Q

  it 'responds to finite?' do
    expect(1.respond_to?(:finite?)).to be true
  end

  it 'returns true if a number is finite' do
    expect(1.finite?).to be true
    expect(1i.finite?).to be true
    expect(Rational(1).finite?).to be true
  end
end
