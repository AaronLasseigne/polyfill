RSpec.describe 'String.new' do
  using Polyfill(String: %w[.new], version: '2.3')

  context 'existing behavior' do
    it 'works' do
      expect(String.new).to eql '' # rubocop:disable all
      expect(String.new('a')).to eql 'a'
    end
  end

  context '2.3' do
    it 'accepts an encoding argument' do
      text = [0xA4, 0xA2].pack('CC').force_encoding 'utf-8'
      str = String.new(text, encoding: 'euc-jp')
      expect(str.encoding).to eql Encoding::EUC_JP
    end

    it 'throws an error on other unknown keywords' do
      expect { String.new(unknown_keyword: true) }.to raise_error(ArgumentError, /unknown keyword: :?unknown_keyword/)
    end
  end
end
