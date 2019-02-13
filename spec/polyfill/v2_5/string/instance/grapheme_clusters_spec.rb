RSpec.describe 'String#grapheme_clusters' do
  using Polyfill(String: %w[#grapheme_clusters], version: '2.5')

  it 'returns each grapheme in an array' do
    nfc = 'à'
    nfd = "a\u{300}"
    graphemes = [nfc, nfd]
    str = graphemes.join

    ignore_warnings do
      expect(str.grapheme_clusters).to eql graphemes
    end
  end

  context 'with block' do
    around do |example|
      ignore_warnings do
        example.run
      end
    end

    it 'yields each element' do
      acc = []
      nfc = 'à'
      nfd = "a\u{300}"
      graphemes = [nfc, nfd]
      str = graphemes.join

      str.grapheme_clusters do |gc|
        acc << gc
      end

      expect(acc).to eql graphemes
    end
  end
end
