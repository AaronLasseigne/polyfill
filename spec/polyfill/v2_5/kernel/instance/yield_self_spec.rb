RSpec.describe 'Kernel#yield_self' do
  using Polyfill(Kernel: %w[#yield_self], version: '2.5')

  it 'yields self' do
    object = Object.new
    object.yield_self { |o| expect(o).to be object }
  end

  it 'returns the block return value' do
    object = Object.new
    expect(object.yield_self { 42 }).to eql 42
  end

  it 'returns a sized Enumerator when no block given' do
    object = Object.new
    enum = object.yield_self

    expect(enum).to be_an_instance_of Enumerator
    expect(enum.size).to eql 1
    expect(enum.peek).to be object
    expect(enum.first).to be object
  end
end
