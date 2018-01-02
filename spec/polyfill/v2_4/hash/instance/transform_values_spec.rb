RSpec.describe 'Hash#transform_values' do
  using Polyfill(Hash: %w[#transform_values], version: '2.4')

  it 'transforms the values of the hash and returns a new one' do
    expect({ a: 1, b: 2, c: 3 }.transform_values { |v| v * v + 1 }).to eql(a: 2, b: 5, c: 10)
    expect({ a: 1, b: 2, c: 3 }.transform_values(&:to_s)).to eql(a: '1', b: '2', c: '3')
  end

  it 'returns an enumerable when no block is given' do
    expect({}.transform_values).to be_an Enumerator
    expect(
      { a: 1, b: 2, c: 3 }.transform_values.with_index { |v, i| "#{v}.#{i}" }
    ).to eql(a: '1.0', b: '2.1', c: '3.2')
  end

  it 'does not modify the original' do
    orig = { a: 1, b: false, c: nil }
    copy = orig.dup
    orig.transform_values(&:to_s)
    expect(orig).to eql copy
  end
end
