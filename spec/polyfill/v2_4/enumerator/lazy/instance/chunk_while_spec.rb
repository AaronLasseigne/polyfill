RSpec.describe 'Enumerator::Lazy#chunk_while' do
  using Polyfill('Enumerator::Lazy': %w[#chunk_while])

  it 'will chunk based on the block' do
    expect(
      [1, 2, 3, 5, 8, 13, 21]
        .lazy
        .chunk_while { |a, b| a.even? == b.even? }
        .force
    ).to eql [[1], [2], [3, 5], [8], [13, 21]]
  end
end
