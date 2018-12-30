RSpec.describe 'Kernel#then' do
  using Polyfill(Kernel: %w[#then], version: '2.6')

  it 'aliases Kernel#then' do
    object = Object.new
    object.then { |o| expect(o).to be object }
    expect(object.then { 42 }).to eql 42
  end

  it 'returns a sized Enumerator when no block given' do
    object = Object.new
    enum = object.then

    expect(enum).to be_an_instance_of Enumerator
    expect(enum.size).to eql 1
    expect(enum.peek).to be object
    expect(enum.first).to be object
  end
end
