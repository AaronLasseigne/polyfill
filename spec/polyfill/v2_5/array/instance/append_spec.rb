RSpec.describe 'Array#append' do
  using Polyfill(Array: %w[#append], version: '2.5')

  it 'aliases Array#push' do
    a = [1]
    a.append(2)
    a.append(3, 4)

    expect(a).to eql [1, 2, 3, 4]
  end
end
