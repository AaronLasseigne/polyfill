RSpec.describe 'Integer#anybits?' do
  using Polyfill(Integer: %w[#anybits?], version: '2.5')

  let(:bignum_value) { 0x8000_0000_0000_0000 }

  it 'returns true iff all the bits of the argument are set in the receiver' do
    expect(42.anybits?(42)).to be true
    expect(0b1010_1010.anybits?(0b1000_0010)).to be true
    expect(0b1010_1010.anybits?(0b1000_0001)).to be true
    expect(0b1000_0010.anybits?(0b0010_1100)).to be false

    different_bignum = (2 * bignum_value) & ~bignum_value
    expect((0b1010_1010 | different_bignum).anybits?(0b1000_0010 | bignum_value)).to be true
    expect((0b1010_1010 | different_bignum).anybits?(0b0010_1100 | bignum_value)).to be true
    expect((0b1000_0010 | different_bignum).anybits?(0b0010_1100 | bignum_value)).to be false
  end

  it "handles negative values using two's complement notation" do
    expect((~42).anybits?(42)).to be false
    expect(-42.anybits?(-42)).to be true
    expect((~0b100).anybits?(~0b1)).to be true
    expect((~(0b100 | bignum_value)).anybits?(~(0b1 | bignum_value))).to be true
  end

  it 'coerces the rhs using to_int' do
    obj = double('the int 0b10')
    expect(obj).to receive(:to_int).and_return(0b10)

    expect(0b110.anybits?(obj)).to be true
  end

  it 'raises a TypeError when given a non-Integer' do
    expect { 13.anybits?('10')    }.to raise_error(TypeError)
    expect { 13.anybits?(:symbol) }.to raise_error(TypeError)
  end
end
