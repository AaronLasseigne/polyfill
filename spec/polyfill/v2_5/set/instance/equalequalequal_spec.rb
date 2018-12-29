require 'set'

RSpec.describe 'Set#===' do
  using Polyfill(Set: %w[#===], version: '2.5')

  it 'aliases Set#include?' do
    s = Set.new([1, 2])

    # rubocop:disable Style/CaseEquality
    expect(s === 2).to be true
    expect(s === 3).to be false
    # rubocop:enable Style/CaseEquality
  end
end
