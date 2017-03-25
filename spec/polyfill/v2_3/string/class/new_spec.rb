RSpec.describe 'String.new' do
  using Polyfill(String: %w[.new])

  context 'existing behavior' do
    it 'works' do
      expect(String.new).to eql '' # rubocop:disable all
      expect(String.new('a')).to eql 'a'
    end
  end

  context '2.3' do
    it 'allows you to use the :encoding option' do
      str = String.new('a', encoding: 'US-ASCII')

      expect(str).to eql 'a'
      expect(str.encoding.name).to eql 'US-ASCII'
    end

    it 'throws an error on other unknown keywords' do
      expect { String.new(unknown_keyword: true) }.to raise_error(ArgumentError, 'unknown keyword: unknown_keyword')
    end
  end
end
