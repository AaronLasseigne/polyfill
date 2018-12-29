require 'set'

RSpec.describe 'Set#to_s' do
  using Polyfill(Set: %w[#to_s], version: '2.5')

  it 'aliases Set#inspect' do
    s = Set.new([1, 2, 3])

    expect(s.to_s).to eql s.inspect
  end
end
