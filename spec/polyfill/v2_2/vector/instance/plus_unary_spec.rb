require 'matrix'

RSpec.describe 'Vector#+@' do
  using Polyfill(Vector: %w[#+@], version: '2.2')

  it 'returns self' do
    obj = Vector[]
    expect(+obj).to be obj
  end
end
