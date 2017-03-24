RSpec.describe 'Symbol#casecmp?' do
  using Polyfill(Symbol: %w[#casecmp?])

  it 'returns true if the symbols are equal after case folding' do
    expect(:abc.casecmp?(:Abc)).to be true
    expect(:Abc.casecmp?(:abc)).to be true
    # expect(:À.casecmp?(:à)).to be true
  end

  it 'returns false if the symbols are not equal after case folding' do
    expect(:abc.casecmp?(:ab)).to be false
  end

  it 'returns nil if the comparison is not a Symbol' do
    expect(:abc.casecmp?('abc')).to be nil
  end
end
