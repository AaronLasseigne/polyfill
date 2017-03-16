RSpec.describe 'Hash#transform_values!' do
  using Polyfill::V2_4::Hash::TransformValuesE

  it 'transforms the values of the hash and returns a new one' do
    expect({ a: 1, b: 2, c: 3 }.transform_values! {|v| v * v + 1 }).to eql(a: 2, b: 5, c: 10)
    expect({ a: 1, b: 2, c: 3 }.transform_values!(&:to_s)).to eql(a: '1', b: '2', c: '3')
    expect({ a: 1 }.transform_values! {}).to eql(a: nil)
  end

  it 'returns an enumerable when no block is given' do
    expect({}.transform_values!).to be_an(Enumerator)
    orig = { a: 1, b: 2, c: 3 }
    orig.transform_values!.with_index { |v, i| "#{v}.#{i}" }
    expect(orig).to eql(a: '1.0', b: '2.1', c: '3.2')
  end

  it 'does modifies the original' do
    orig = { a: 1, b: false, c: nil }
    orig.transform_values!(&:to_s)
    expect(orig).to eql(a: '1', b: 'false', c: '')
  end
end
