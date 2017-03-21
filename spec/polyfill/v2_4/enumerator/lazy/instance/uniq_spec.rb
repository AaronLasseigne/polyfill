RSpec.describe 'Enumerator::Lazy#uniq' do
  using Polyfill('Enumerator::Lazy': %w[#uniq])

  it 'uniques the elements' do
    expect([1, 1, 2].lazy.uniq.force).to eql [1, 2]
    expect({ one: 1, two: 2 }.lazy.uniq.force).to eql [[:one, 1], [:two, 2]]
  end

  it 'will base uniqueness off of the block' do
    expect(
      [1, 2, 3].lazy.uniq { |n| n % 2 }.force
    ).to eql [1, 2]
    expect(
      { one: 1, two: 2, three: 3 }.lazy.uniq { |_, v| v % 2 }.force
    ).to eql [[:one, 1], [:two, 2]]
  end
end
