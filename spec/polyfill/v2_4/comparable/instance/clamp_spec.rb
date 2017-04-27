RSpec.describe 'Comparable#clamp' do
  using Polyfill(Comparable: %w[#clamp])

  it 'returns the value if it is between min and max' do
    expect(12.clamp(0, 100)).to eql 12
    expect(12.0.clamp(0.0, 100.0)).to eql 12.0
    expect('d'.clamp('a', 'z')).to eql 'd'

    t = Time.now
    expect(t.clamp(t - 1, t + 1)).to eql t
  end

  it 'moves the value to min if it is under that' do
    expect(-12.clamp(0, 100)).to eql 0
    expect(-12.0.clamp(0.0, 100.0)).to eql 0.0
    expect('d'.clamp('q', 'z')).to eql 'q'

    t = Time.now
    expect(t.clamp(t + 1, t + 2)).to eql t + 1
  end

  it 'moves the value to max if it is over that' do
    expect(120.clamp(0, 100)).to eql 100
    expect(120.0.clamp(0.0, 100.0)).to eql 100.0
    expect('z'.clamp('a', 'q')).to eql 'q'

    t = Time.now
    expect(t.clamp(t - 2, t - 1)).to eql t - 1
  end

  it 'throws an ArgumentError when min is greater than max' do
    expect { 1.clamp(5, 1) }.to raise_error(ArgumentError, 'min argument must be smaller than max argument')
  end

  it 'throws an error when min and max are incomparable types' do
    expect(100.clamp(5, 10.5)).to eql 10.5
    expect { 100.clamp('a', 10) }.to raise_error(ArgumentError, 'comparison of String with 10 failed')
  end
end
