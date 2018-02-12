RSpec.describe 'Integer#nobits?' do
  using Polyfill(Integer: %w[#nobits?], version: '2.5')

  let(:bignum_value) { 0x8000_0000_0000_0000 }

  it 'returns true iff all no bits of the argument are set in the receiver' do
    expect(42.nobits?(42)).to be false
    expect(0b1010_1010.nobits?(0b1000_0010)).to be false
    expect(0b1010_1010.nobits?(0b1000_0001)).to be false
    expect(0b0100_0101.nobits?(0b1010_1010)).to be true

    different_bignum = (2 * bignum_value) & ~bignum_value
    expect((0b1010_1010 | different_bignum).nobits?(0b1000_0010 | bignum_value)).to be false
    expect((0b1010_1010 | different_bignum).nobits?(0b1000_0001 | bignum_value)).to be false
    expect((0b0100_0101 | different_bignum).nobits?(0b1010_1010 | bignum_value)).to be true
  end

  it "handles negative values using two's complement notation" do
    expect((~0b1101).nobits?(0b1101)).to be true
    expect(-42.nobits?(-42)).to be false
    expect((~0b1101).nobits?(~0b10)).to be false
    expect((~(0b1101 | bignum_value)).nobits?(~(0b10 | bignum_value))).to be false
  end

  it 'coerces the rhs using to_int' do
    obj = double('the int 0b10')
    expect(obj).to receive(:to_int).and_return(0b10)

    expect(0b110.nobits?(obj)).to be false
  end

  it 'raises a TypeError when given a non-Integer' do
    expect { 13.nobits?('10')    }.to raise_error(TypeError)
    expect { 13.nobits?(:symbol) }.to raise_error(TypeError)
  end
end
