RSpec.describe 'Regexp#match?' do
  using Polyfill(Regexp: %w[#match?], version: '2.4')

  it 'returns true if the pattern matches' do
    expect(/R.../.match?('Ruby')).to be true
    expect(//.match?('Ruby', 4)).to be true
  end

  it 'returns false if the pattern does not match' do
    expect(/P.../.match?('Ruby')).to be false
  end

  it 'returns false if the pattern does not match because of the position' do
    expect(/R.../.match?('Ruby', 1)).to be false
  end

  it 'does not set global variables' do
    /R.../.match?('Ruby')
    expect($&).to be nil
  end
end
