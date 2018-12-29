RSpec.describe 'Array#prepend' do
  using Polyfill(Array: %w[#prepend], version: '2.5')

  it 'aliases Array#unshift' do
    a = [1]
    a.prepend(2)
    a.prepend(3, 4)

    expect(a).to eql [3, 4, 2, 1]
  end
end
