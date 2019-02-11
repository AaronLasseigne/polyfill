RSpec.describe 'Array#difference' do
  using Polyfill(Array: %w[#difference], version: '2.6')

  it 'returns a copy when called without any parameter' do
    x = [1, 2, 3, 2]
    expect(x.difference).to eql x
    expect(x.difference).to_not equal x
  end

  it 'does not return subclass instances for Array subclasses' do
    my_array = Class.new(Array)
    expect(my_array[1, 2, 3].difference).to be_an_instance_of(Array)
  end

  it 'accepts multiple arguments' do
    x = [1, 2, 3, 1]
    expect(x.difference([], [0, 1], [3, 4], [3])).to eql [2]
  end
end
