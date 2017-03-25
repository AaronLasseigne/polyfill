require 'stringio'

RSpec.describe 'Enumerable#chunk' do
  using Polyfill(Enumerable: %w[#chunk])

  def fixture(file_name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  context 'existing behavior' do
    it 'works' do
      expect(
        [1, 2, 4, 5, 7].chunk { |n| n % 2 }.to_a
      ).to eql [[1, [1]], [0, [2, 4]], [1, [5, 7]]]
    end
  end

  context '2.4' do
    it 'returns an Enumerator when no block is given' do
      expect([].chunk).to be_an Enumerator
      expect(Dir.new('.').chunk).to be_an Enumerator
      expect(Enumerator.new {}.chunk).to be_an Enumerator
      expect({}.chunk).to be_an Enumerator
      expect(
        IO.new(IO.sysopen(fixture('file.txt'))).chunk
      ).to be_an Enumerator
      expect((1..2).chunk).to be_an Enumerator
      expect(StringIO.new('').chunk).to be_an Enumerator
      expect(Struct.new(:a).new('').chunk).to be_an Enumerator
    end

    it 'is chainable' do
      expect(
        [1, 2, 4, 5, 7].chunk.with_index { |n, i| (n % 2) + i }.to_a
      ).to eql [[1, [1, 2]], [2, [4]], [4, [5]], [5, [7]]]
    end
  end
end
