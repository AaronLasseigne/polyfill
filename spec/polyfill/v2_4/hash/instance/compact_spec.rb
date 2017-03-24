RSpec.describe 'Hash#compact' do
  using Polyfill(Hash: %w[#compact])

  it 'removes keys with nil values' do
    expect({ a: 1, b: false, c: nil }.compact).to eql(a: 1, b: false)
  end

  it 'returns everything if nothing changes' do
    expect({ a: 1 }.compact).to eql(a: 1)
  end

  it 'does not modify the original' do
    orig = { a: 1, b: false, c: nil }
    copy = orig.dup
    orig.compact
    expect(orig).to eql copy
  end
end
