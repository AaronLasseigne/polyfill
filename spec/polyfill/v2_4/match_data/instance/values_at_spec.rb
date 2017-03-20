RSpec.describe 'MatchData#values_at' do
  using Polyfill(MatchData: %w[#values_at])

  context 'existing behavior' do
    it 'works as expected' do
      m = 'abc'.match(/(.)(.)(.)/)
      expect(m.values_at(0, 2)).to eql %w[abc b]
      expect(m.values_at).to eql []
    end
  end

  context '2.4' do
    it 'allows capture groups' do
      m = 'abc'.match(/(?<one>.)(?<two>.)(?<three>.)/)
      expect(m.values_at(:one, :three)).to eql %w[a c]
      expect(m.values_at(:one, 3)).to eql %w[a c]
    end

    it 'throws an error on a bad reference' do
      m = 'abc'.match(/(.)/)
      expect { m.values_at(:foo) }.to raise_error(IndexError, 'undefined group name reference: foo')
      expect { m.values_at('foo') }.to raise_error(IndexError, 'undefined group name reference: foo')
    end
  end
end
