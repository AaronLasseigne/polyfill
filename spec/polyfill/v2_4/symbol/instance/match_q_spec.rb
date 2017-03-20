RSpec.describe 'Symbol#match?' do
  using Polyfill(Symbol: %w[#match?])

  it 'returns true if the pattern matches' do
    expect(:Ruby.match?(/R.../)).to be true
    expect(:Ruby.match?(//, 4)).to be true
  end

  it 'returns false if the pattern does not match' do
    expect(:Ruby.match?(/P.../)).to be false
  end

  it 'returns false if the pattern does not match because of the position' do
    expect(:Ruby.match?(/R.../, 1)).to be false
  end

  it 'does not set global variables' do
    :Ruby.match?(/R.../)
    expect($&).to be nil
  end
end
