RSpec.describe 'Hash#merge' do
  using Polyfill(Hash: %w[#merge], version: '2.6')

  it 'allows no arguments' do
    h = { one: 1 }
    h2 = h.merge

    expect(h).to eql h2
    expect(h.object_id).to_not eql h2.object_id
  end

  it 'allows multiple arguments' do
    h = {}
    h1 = { one: 1 }
    h2 = { two: 2 }

    expect(h.merge(h1)).to eql h1
    expect(h.merge(h1, h2)).to eql h1.merge(h2)
  end
end
