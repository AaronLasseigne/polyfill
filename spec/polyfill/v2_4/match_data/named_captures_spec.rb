RSpec.describe 'MatchData#named_captures' do
  using Polyfill::V2_4::MatchData::NamedCaptures

  it 'responds to named_captures' do
    expect('a'.match(//).respond_to?(:named_captures)).to be true
    expect('a'.match(//).methods).to include :named_captures
    expect(MatchData.instance_methods).to include :named_captures
  end

  it 'returns a hash of named captures' do
    m = /(?<a>.)(?<b>.)/.match('01')
    expect(m.named_captures).to eql('a' => '0', 'b' => '1')
  end

  it 'returns nil for unmatched captures' do
    m = /(?<a>.)(?<b>.)?/.match('0')
    expect(m.named_captures).to eql('a' => '0', 'b' => nil)
  end

  it 'returns the last successful capture for a name' do
    m = /(?<a>.)(?<a>.)/.match('01')
    expect(m.named_captures).to eql('a' => '1')

    m = /(?<a>x)|(?<a>y)/.match('x')
    expect(m.named_captures).to eql('a' => 'x')
  end
end
