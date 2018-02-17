require 'English'

RSpec.describe 'String#delete_suffix!' do
  using Polyfill(String: %w[#delete_suffix!], version: '2.5')

  it 'removes the found prefix' do
    s = 'hello'

    expect(s.delete_suffix!('ello')).to be s
    expect(s).to eql 'h'
  end

  it 'returns nil if no change is made' do
    s = 'hello'
    expect(s.delete_suffix!('ell')).to be nil
    expect(s.delete_suffix!('')).to be nil
  end

  it "doesn't set $LAST_MATCH_INFO" do
    $LAST_MATCH_INFO = nil

    'hello'.delete_suffix!('ello')
    expect($LAST_MATCH_INFO).to be nil
  end

  it 'calls to_str on its argument' do
    o = double('x')
    expect(o).to receive(:to_str).and_return 'ello'

    expect('hello'.delete_suffix!(o)).to eql 'h'
  end

  it "raises a #{frozen_error_class} when self is frozen" do
    expect { 'hello'.freeze.delete_suffix!('ello') }.to raise_error(frozen_error_class)
    expect { 'hello'.freeze.delete_suffix!('') }.to raise_error(frozen_error_class)
    expect { ''.freeze.delete_suffix!('') }.to raise_error(frozen_error_class)
  end

  it 'throws a TypeError if a the argument passed is not a string' do
    expect { 'abc'.delete_suffix!(1) }.to raise_error TypeError
  end
end
