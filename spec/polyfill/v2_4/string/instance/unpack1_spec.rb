RSpec.describe 'String#unpack1' do
  using Polyfill(String: %w[#unpack1])

  it 'returns the first result of unpacking the string' do
    expect("abc \0\0abc \0\0".unpack1('A6Z6')).to eql 'abc'
  end
end
