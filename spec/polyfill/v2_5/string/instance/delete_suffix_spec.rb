require 'English'

RSpec.describe 'String#delete_suffix' do
  using Polyfill(String: %w[#delete_suffix], version: '2.5')

  it 'returns a copy of the string, with the given suffix removed' do
    expect('hello'.delete_suffix('ello')).to eql 'h'
    expect('hello'.delete_suffix('hello')).to eql ''
  end

  it "returns a copy of the string, when the suffix isn't found" do
    s = 'hello'
    r = s.delete_suffix('!hello')

    expect(r).to_not be s
    expect(r).to eql s

    r = s.delete_suffix('ell')
    expect(r).to_not be s
    expect(r).to eql s

    r = s.delete_suffix('')
    expect(r).to_not be s
    expect(r).to eql s
  end

  it 'taints resulting strings when other is tainted' do
    expect('hello'.taint.delete_suffix('ello').tainted?).to be true
    expect('hello'.taint.delete_suffix('').tainted?).to be true
  end

  it "doesn't set $LAST_MATCH_INFO" do
    $LAST_MATCH_INFO = nil

    'hello'.delete_suffix('ello')
    expect($LAST_MATCH_INFO).to be nil
  end

  it 'calls to_str on its argument' do
    o = double('x')
    expect(o).to receive(:to_str).and_return 'ello'

    expect('hello'.delete_suffix(o)).to eql 'h'
  end

  it 'returns a subclass instance when called on a subclass instance' do
    klass = Class.new(String)
    s = klass.new('hello')

    expect(s.delete_suffix('ello')).to be_an_instance_of(klass)
  end

  it 'throws a TypeError if a the argument passed is not a string' do
    expect { 'abc'.delete_suffix(1) }.to raise_error TypeError
  end
end
