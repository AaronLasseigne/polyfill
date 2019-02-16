RSpec.describe 'String#each_grapheme_cluster' do
  using Polyfill(String: %w[#each_grapheme_cluster], version: '2.5')

  context 'without block' do
    it 'returns an enumerator' do
      expect('a'.each_grapheme_cluster).to be_an Enumerator
    end

    it 'returns each element' do
      nfc = 'à'
      nfd = "a\u{300}"
      graphemes = [nfc, nfd]
      str = graphemes.join

      ignore_warnings do
        expect(str.each_grapheme_cluster.to_a).to eql graphemes
      end
    end

    it 'has a size' do
      nfc = 'à'
      nfd = "a\u{300}"
      str = "#{nfc}#{nfd}"

      expect(str.each_grapheme_cluster.size).to eql 2
    end
  end

  context 'with block' do
    it 'yields each element' do
      acc = []
      nfc = 'à'
      nfd = "a\u{300}"
      graphemes = [nfc, nfd]
      str = graphemes.join

      ignore_warnings do
        str.each_grapheme_cluster do |gc|
          acc << gc
        end
      end

      expect(acc).to eql graphemes
    end
  end
end
