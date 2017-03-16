RSpec.describe 'MatchData#named_captures' do
  using Polyfill::V2_4::MatchData::NamedCaptures

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
