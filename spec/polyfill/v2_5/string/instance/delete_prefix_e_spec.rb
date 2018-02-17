require 'English'

RSpec.describe 'String#delete_prefix!' do
  using Polyfill(String: %w[#delete_prefix!], version: '2.5')

  it 'removes the found prefix' do
    s = 'hello'

    expect(s.delete_prefix!('hell')).to be s
    expect(s).to eql 'o'
  end

  it 'returns nil if no change is made' do
    s = 'hello'

    expect(s.delete_prefix!('ell')).to be nil
    expect(s.delete_prefix!('')).to be nil
  end

  it "doesn't set $LAST_MATCH_INFO" do
    $LAST_MATCH_INFO = nil

    'hello'.delete_prefix!('hell')
    expect($LAST_MATCH_INFO).to be nil
  end

  it 'calls to_str on its argument' do
    o = double('x')
    expect(o).to receive(:to_str).and_return 'hell'

    expect('hello'.delete_prefix!(o)).to eql 'o'
  end

  it "raises a #{frozen_error_class} when self is frozen" do
    expect { 'hello'.freeze.delete_prefix!('hell') }.to raise_error(frozen_error_class)
    expect { 'hello'.freeze.delete_prefix!('') }.to raise_error(frozen_error_class)
    expect { ''.freeze.delete_prefix!('') }.to raise_error(frozen_error_class)

    expect do
      begin
        ''.freeze.delete_prefix!('')
      rescue frozen_error_class
        throw(:working)
      end
    end.to throw_symbol(:working)
  end

  it 'throws a TypeError if a the argument passed is not a string' do
    expect { 'abc'.delete_prefix!(1) }.to raise_error TypeError
  end
end
