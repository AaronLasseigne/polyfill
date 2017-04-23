RSpec.describe 'Array#sum' do
  using Polyfill(Array: %w[#sum])

  it 'sums the elements with an initial value (default 0)' do
    expect([1, 2, 3].sum).to eql 6
    expect([1, 2, 3].sum(2)).to eql 8
  end

  it 'will take a block and add the result' do
    expect([1, 2, 3].sum { |n| n * 2 }).to eql 12
  end

  it 'does not modify the object passed' do
    init = ''
    expect(%w[a b c].sum(init)).to eql 'abc'
    expect(init).to eql ''

    init = ''.freeze
    expect(%w[a b c].sum(init)).to eql 'abc'
    expect(init).to eql ''
  end

  it 'does not use each' do
    obj = [1, 2, 3]
    expect(obj).to_not receive(:each)

    expect(obj.sum).to eql 6
  end
end
