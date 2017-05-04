require 'matrix'

RSpec.describe 'Vector#+@' do
  using Polyfill(Vector: %w[#+@])

  it 'returns self' do
    obj = Vector[]
    expect(+obj).to be obj
  end
end
