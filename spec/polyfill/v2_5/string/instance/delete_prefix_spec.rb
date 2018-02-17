require 'English'

RSpec.describe 'String#delete_prefix' do
  using Polyfill(String: %w[#delete_prefix], version: '2.5')

  it 'returns a copy of the string, with the given prefix removed' do
    expect('hello'.delete_prefix('hell')).to eql 'o'
    expect('hello'.delete_prefix('hello')).to eql ''
  end

  it "returns a copy of the string, when the prefix isn't found" do
    s = 'hello'
    r = s.delete_prefix('hello!')

    expect(r).to_not be s
    expect(r).to eql s

    r = s.delete_prefix('ell')
    expect(r).to_not be s
    expect(r).to eql s

    r = s.delete_prefix('')
    expect(r).to_not be s
    expect(r).to eql s
  end

  it 'taints resulting strings when other is tainted' do
    expect('hello'.taint.delete_prefix('hell').tainted?).to be true
    expect('hello'.taint.delete_prefix('').tainted?).to be true
  end

  it "doesn't set $LAST_MATCH_INFO" do
    $LAST_MATCH_INFO = nil

    'hello'.delete_prefix('hell')
    expect($LAST_MATCH_INFO).to be nil
  end

  it 'calls to_str on its argument' do
    o = double('x')
    expect(o).to receive(:to_str).and_return 'hell'

    expect('hello'.delete_prefix(o)).to eql 'o'
  end

  it 'returns a subclass instance when called on a subclass instance' do
    klass = Class.new(String)
    s = klass.new('hello')

    expect(s.delete_prefix('hell')).to be_an_instance_of(klass)
  end

  it 'throws a TypeError if a the argument passed is not a string' do
    expect { 'abc'.delete_prefix(1) }.to raise_error TypeError
  end
end
