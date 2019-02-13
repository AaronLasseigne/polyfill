RSpec.describe 'Array#union' do
  using Polyfill(Array: %w[#union], version: '2.6')

  it 'returns unique elements when given no argument' do
    x = [1, 2, 3, 2]
    expect(x.union).to eql [1, 2, 3]
  end

  it 'does not return subclass instances for Array subclasses' do
    my_array = Class.new(Array)
    expect(my_array[1, 2, 3].union).to be_an_instance_of(Array)
    expect(my_array[1, 2, 3].union(my_array[1, 2])).to be_an_instance_of(Array)
  end

  it 'accepts multiple arguments' do
    x = [1, 2, 3]
    expect(x.union(x, x, x, x, [3, 4], x)).to eql [1, 2, 3, 4]
  end
end
