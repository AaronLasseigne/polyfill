RSpec.describe 'String.new' do
  using Polyfill(String: %w[.new])

  context 'existing behavior' do
    it 'works' do
      expect(String.new).to eql '' # rubocop:disable all
      expect(String.new('a')).to eql 'a'
      expect(String.new('', encoding: 'US-ASCII').encoding.name).to eql 'US-ASCII'
    end
  end

  context '2.4' do
    it 'allows you to use the :capacity option' do
      expect(String.new('', capacity: 100)).to eql ''
      expect(String.new('', encoding: 'US-ASCII', capacity: 100)).to eql ''
      expect(String.new(encoding: 'US-ASCII', capacity: 100)).to eql ''
      expect(String.new(capacity: 100)).to eql ''
    end

    it 'throws an error on other unknown keywords' do
      expect { String.new(unknown_keyword: true) }.to raise_error(ArgumentError)
    end
  end
end
