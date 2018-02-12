RSpec.describe 'Integer#allbits?' do
  using Polyfill(Integer: %w[#allbits?], version: '2.5')

  let(:bignum_value) { 0x8000_0000_0000_0000 }

  it 'returns true iff all the bits of the argument are set in the receiver' do
    expect(42.allbits?(42)).to be true
    expect(0b1010_1010.allbits?(0b1000_0010)).to be true
    expect(0b1010_1010.allbits?(0b1000_0001)).to be false
    expect(0b1000_0010.allbits?(0b1010_1010)).to be false
    expect((0b1010_1010 | bignum_value).allbits?(0b1000_0010 | bignum_value)).to be true
    expect((0b1010_1010 | bignum_value).allbits?(0b1000_0001 | bignum_value)).to be false
    expect((0b1000_0010 | bignum_value).allbits?(0b1010_1010 | bignum_value)).to be false
  end

  it "handles negative values using two's complement notation" do
    expect((~0b1).allbits?(42)).to be true
    expect(-42.allbits?(-42)).to be true
    expect((~0b1010_1010).allbits?(~0b1110_1011)).to be true
    expect((~0b1010_1010).allbits?(~0b1000_0010)).to be false
    expect((~(0b1010_1010 | bignum_value)).allbits?(~(0b1110_1011 | bignum_value))).to be true
    expect((~(0b1010_1010 | bignum_value)).allbits?(~(0b1000_0010 | bignum_value))).to be false
  end

  it 'coerces the rhs using to_int' do
    obj = double('the int 0b10')
    expect(obj).to receive(:to_int).and_return(0b10)

    expect(0b110.allbits?(obj)).to be true
  end

  it 'raises a TypeError when given a non-Integer' do
    expect { 13.allbits?('10')    }.to raise_error(TypeError)
    expect { 13.allbits?(:symbol) }.to raise_error(TypeError)
  end
end
