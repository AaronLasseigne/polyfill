RSpec.describe 'String#split' do
  using Polyfill(String: %w[#split], version: '2.6')

  it 'splits a string' do
    expect('a b'.split(' ')).to eql %w[a b]
  end

  it 'yields each split substrings if a block is given' do
    a = []
    returned_object = 'chunky bacon'.split(' ') { |str| a << str.capitalize }

    expect(returned_object).to eql 'chunky bacon'
    expect(a).to eql %w[Chunky Bacon]
  end

  context 'for a String subclass' do
    it 'yields instances of the same subclass' do
      a = []
      MyString = Class.new(String)
      MyString.new('a|b').split('|') { |str| a << str }
      first, last = a

      expect(first).to be_an_instance_of(MyString)
      expect(first).to eql 'a'

      expect(last).to be_an_instance_of(MyString)
      expect(last).to eql 'b'
    end
  end
end
