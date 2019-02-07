RSpec.describe 'Enumerable#max' do
  using Polyfill(Enumerable: %w[#max], version: '2.2')

  let(:e_strs) { %w[333 22 666666 1 55555 1010101010] }
  let(:e_ints) { [333, 22, 666_666, 55_555, 1_010_101_010] }

  it 'returns the maximum element (basics cases)' do
    expect([55].max).to eql 55

    expect([11, 99].max).to eql 99
    expect([99, 11].max).to eql 99
    expect([2, 33, 4, 11].max).to eql 33

    expect([1, 2, 3, 4, 5].max).to eql 5
    expect([5, 4, 3, 2, 1].max).to eql 5
    expect([1, 4, 3, 5, 2].max).to eql 5
    expect([5, 5, 5, 5, 5].max).to eql 5

    expect(%w[aa tt].max).to eql 'tt'
    expect(%w[tt aa].max).to eql 'tt'
    expect(%w[2 33 4 11].max).to eql '4'

    expect(e_strs.max).to eql '666666'
    expect(e_ints.max).to eql 1_010_101_010
  end

  it 'returns nil for an empty Enumerable' do
    expect([].max).to be nil
  end

  it 'raises a NoMethodError for elements without #<=>' do
    expect do
      [BasicObject.new, BasicObject.new].max
    end.to raise_error(NoMethodError)
  end

  it 'raises an ArgumentError for incomparable elements' do
    expect do
      [11, '22'].max
    end.to raise_error(ArgumentError)
    expect do
      [11, 12, 22, 33].max { |_, _| nil }
    end.to raise_error(ArgumentError)
  end

  context 'when passed a block' do
    it 'returns the maximum element' do
      expect(%w[2 33 4 11].max { |a, b| a <=> b }).to eql '4'
      expect([2, 33, 4, 11].max { |a, b| a <=> b }).to eql 33

      expect(%w[2 33 4 11].max { |a, b| b <=> a }).to eql '11'
      expect([2, 33, 4, 11].max { |a, b| b <=> a }).to eql 2

      # rubocop:disable Performance/CompareWithBlock
      expect(e_strs.max { |a, b| a.length <=> b.length }).to eql '1010101010'
      # rubocop:enable Performance/CompareWithBlock

      expect(e_strs.max { |a, b| a <=> b }).to eql '666666'
      expect(e_strs.max { |a, b| a.to_i <=> b.to_i }).to eql '1010101010' # rubocop:disable Performance/CompareWithBlock

      expect(e_ints.max { |a, b| a <=> b }).to eql 1_010_101_010
      expect(e_ints.max { |a, b| a.to_s <=> b.to_s }).to eql 666_666 # rubocop:disable Performance/CompareWithBlock
    end
  end

  it 'returns the maximum for enumerables that contain nils' do
    expect(
      [nil, nil, true].max do |a, b|
        x = if a.nil?
              1
            else
              a ? 0 : -1
            end
        y = if b.nil?
              1
            else
              b ? 0 : -1
            end

        x <=> y
      end
    ).to be nil
  end

  it 'gathers whole arrays as elements when each yields multiple' do
    multi = Class.new do
      include Enumerable
      include Polyfill.get(:Enumerable, %i[max])

      def each
        yield 1, 2
        yield 6, 7, 8, 9
        yield 3, 4, 5
      end
    end.new

    expect(multi.max).to eql [6, 7, 8, 9]
  end

  context 'when called with an argument n' do
    context 'without a block' do
      it 'returns an array containing the maximum n elements' do
        expect(e_ints.max(2)).to eql [1_010_101_010, 666_666]
      end
    end

    context 'with a block' do
      it 'returns an array containing the maximum n elements' do
        expect(e_ints.max(2) { |a, b| a * 2 <=> b * 2 }).to eql [1_010_101_010, 666_666]
      end
    end

    context 'on a enumerable of length x where x < n' do
      it 'returns an array containing the maximum n elements of length x' do
        expect(e_ints.max(500).length).to eql 5
      end
    end

    context 'that is negative' do
      it 'raises an ArgumentError' do
        expect { e_ints.max(-1) }.to raise_error(ArgumentError, 'negative size (-1)')
      end
    end
  end

  context 'that is nil' do
    it 'returns the maximum element' do
      expect(e_ints.max(nil)).to eql 1_010_101_010
    end
  end
end
