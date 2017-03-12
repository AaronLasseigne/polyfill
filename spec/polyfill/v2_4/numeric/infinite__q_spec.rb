RSpec.describe 'Numeric#infinite?' do
  using Polyfill::V2_4::Numeric::Infinite__Q

  it 'returns nil if a number is not infinite' do
    expect(1.infinite?).to be nil
    expect(1i.infinite?).to be nil
    expect(Rational(1).infinite?).to be nil
  end
end
