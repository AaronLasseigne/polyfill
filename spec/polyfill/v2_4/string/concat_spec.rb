RSpec.describe 'String#concat' do
  using Polyfill::V2_4::String::Concat

  context 'existing behavior' do
    it 'concatenates the given argument to self and returns self' do
      str = 'hello '
      expect(str.concat('world')).to be str
      expect(str).to eql 'hello world'
    end
  end

  context '2.4' do
    it 'takes multiple arguments' do
      str = 'hello '
      str.concat 'wo', '', 'rld'
      expect(str).to eql 'hello world'
    end

    it 'concatenates the initial value when given arguments contain 2 self' do
      str = 'hello'
      str.concat str, str
      expect(str).to eql 'hellohellohello'
    end

    it 'returns self when given no arguments' do
      str = 'hello'
      expect(str.concat).to be str
      expect(str).to eql 'hello'
    end
  end
end
