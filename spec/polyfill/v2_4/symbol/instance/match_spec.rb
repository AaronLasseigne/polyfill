RSpec.describe 'Symbol#match' do
  using Polyfill(Symbol: %w[#match])

  it 'returns a match object that is the same as the string version' do
    expect(:Ruby.match(/R.../)).to eql 'Ruby'.match(/R.../)
  end

  it 'returns nil if there is no match' do
    expect(:Ruby.match(/P.../)).to be nil
  end

  it 'sends the match object to the block' do
    obj = nil
    :Ruby.match(/R.../) do |m|
      obj = m
    end

    expect(obj).to be_a MatchData
  end
end
