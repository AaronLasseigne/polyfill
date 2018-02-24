RSpec.describe 'Integer.sqrt' do
  using Polyfill(Integer: %w[.sqrt], version: '2.5')

  it 'returns an integer' do
    expect(Integer.sqrt(10)).to be_kind_of(Integer)
  end

  it 'returns the integer square root of the argument' do
    expect(Integer.sqrt(0)).to eql 0
    expect(Integer.sqrt(1)).to eql 1
    expect(Integer.sqrt(24)).to eql 4
    expect(Integer.sqrt(25)).to eql 5
    expect(Integer.sqrt(10**46)).to eql 100_000_000_000_000_000_000_000
    expect(Integer.sqrt(10**400)).to eql 10**200
  end

  it 'raises a Math::DomainError if the argument is negative' do
    expect { Integer.sqrt(-4) }.to raise_error(Math::DomainError)
  end

  it 'accepts any argument that can be coerced to Integer' do
    expect(Integer.sqrt(10.0)).to eql 3
  end

  it 'converts the argument with #to_int' do
    value = double('value')
    expect(value).to receive(:to_int).and_return(9)
    Integer.sqrt(value)
  end

  it 'raises a TypeError if the argument cannot be coerced to Integer' do
    expect { Integer.sqrt('test') }.to raise_error(TypeError)
  end
end
