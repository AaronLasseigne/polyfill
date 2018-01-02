RSpec.describe 'String#casecmp?' do
  using Polyfill(String: %w[#casecmp?], version: '2.4')

  it 'returns true if the strings are equal after case folding' do
    expect('abc'.casecmp?('Abc')).to be true
    expect('Abc'.casecmp?('abc')).to be true
    # expect('À'.casecmp?('à')).to be true
  end

  it 'tries to convert the other string with to_str' do
    obj = double('to_str')
    allow(obj).to receive(:to_str).and_return('abc')
    expect('Abc'.casecmp?(obj)).to be true
  end

  it 'returns false if the strings are not equal after case folding' do
    expect('abc'.casecmp?('ab')).to be false
  end
end
