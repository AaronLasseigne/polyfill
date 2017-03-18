RSpec.describe 'String#prepend' do
  using Polyfill(String: %w[#prepend])

  context 'existing behavior' do
    it 'prepends the given argument to self and returns self' do
      str = 'world'
      expect(str.prepend('hello ')).to be str
      expect(str).to eql 'hello world'
    end
  end

  context '2.4' do
    it 'takes multiple arguments' do
      str = ' world'
      str.prepend 'he', '', 'llo'
      expect(str).to eql 'hello world'
    end

    it 'prepends the initial value when given arguments contain 2 self' do
      str = 'hello'
      str.prepend str, str
      expect(str).to eql 'hellohellohello'
    end

    it 'returns self when given no arguments' do
      str = 'hello'
      expect(str.prepend).to be str
      expect(str).to eql 'hello'
    end
  end
end
