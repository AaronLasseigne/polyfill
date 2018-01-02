RSpec.describe 'String#-@' do
  using Polyfill(String: %w[#-@], version: '2.3')

  it 'returns self if the String is frozen' do
    input  = 'foo'.freeze
    output = -input

    expect(output.frozen?).to be true
    expect(output).to be input
  end

  it 'returns a frozen copy if the String is not frozen' do
    input  = 'foo'
    output = -input

    expect(input.frozen?).to be false
    expect(output.frozen?).to be true
    expect(output).to eql 'foo'
  end
end
