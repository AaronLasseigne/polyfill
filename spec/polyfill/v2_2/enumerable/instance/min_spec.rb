RSpec.describe 'Enumerable#min' do
  using Polyfill(Enumerable: %w[#min], version: '2.2')

  let(:e_strs) { %w[333 22 666666 1 55555 1010101010] }
  let(:e_ints) { [333, 22, 666_666, 55_555, 1_010_101_010] }

  it 'returns the minimum (basic cases)' do
    expect([55].min).to eql 55

    expect([11, 99].min).to eql  11
    expect([99, 11].min).to eql 11
    expect([2,  33,  4, 11].min).to eql 2

    expect([1, 2, 3, 4, 5].min).to eql 1
    expect([5, 4, 3, 2, 1].min).to eql 1
    expect([4, 1, 3, 5, 2].min).to eql 1
    expect([5, 5, 5, 5, 5].min).to eql 5

    expect(%w[aa tt].min).to eql 'aa'
    expect(%w[tt aa].min).to eql 'aa'
    expect(%w[2 33 4 11].min).to eql '11'

    expect(e_strs.min).to eql '1'
    expect(e_ints.min).to eql 22
  end

  it 'returns nil for an empty Enumerable' do
    expect([].min).to be nil
  end

  it 'raises a NoMethodError for elements without #<=>' do
    expect do
      [BasicObject.new, BasicObject.new].min
    end.to raise_error(NoMethodError)
  end

  it 'raises an ArgumentError for incomparable elements' do
    expect do
      [11, '22'].min
    end.to raise_error(ArgumentError)
    expect do
      [11, 12, 22, 33].min { |_, _| nil }
    end.to raise_error(ArgumentError)
  end

  it 'returns the minimum when using a block rule' do
    expect(%w[2 33 4 11].min { |a, b| a <=> b }).to eql '11'
    expect([2, 33, 4, 11].min { |a, b| a <=> b }).to eql 2

    expect(%w[2 33 4 11].min { |a, b| b <=> a }).to eql '4'
    expect([2, 33, 4, 11].min { |a, b| b <=> a }).to eql 33

    expect([1, 2, 3, 4].min { |_, _| 15 }).to eql 1

    expect([11, 12, 22, 33].min { |_, _| 2 }).to eql 11
    i = -2
    expect([11, 12, 22, 33].min { |_, _| i += 1 }).to eql 12

    # rubocop:disable Performance/CompareWithBlock
    expect(e_strs.min { |a, b| a.length <=> b.length }).to eql '1'
    # rubocop:enable Performance/CompareWithBlock

    expect(e_strs.min { |a, b| a <=> b }).to eql '1'
    expect(e_strs.min { |a, b| a.to_i <=> b.to_i }).to eql '1' # rubocop:disable Performance/CompareWithBlock

    expect(e_ints.min { |a, b| a <=> b }).to eql 22
    expect(e_ints.min { |a, b| a.to_s <=> b.to_s }).to eql 1_010_101_010 # rubocop:disable Performance/CompareWithBlock
  end

  it 'returns the minimum for enumerables that contain nils' do
    expect(
      [nil, nil, true].min do |a, b|
        x = if a.nil?
              -1
            else
              a ? 0 : 1
            end
        y = if b.nil?
              -1
            else
              b ? 0 : 1
            end

        x <=> y
      end
    ).to be nil
  end

  it 'gathers whole arrays as elements when each yields multiple' do
    multi = Class.new do
      include Enumerable
      include Polyfill.get(:Enumerable, %i[min])

      def each
        yield 3, 4, 5
        yield 1, 2
        yield 6, 7, 8, 9
      end
    end.new

    expect(multi.min).to eql [1, 2]
  end

  context 'when called with an argument n' do
    context 'without a block' do
      it 'returns an array containing the minimum n elements' do
        expect(e_ints.min(2)).to eql [22, 333]
      end
    end

    context 'with a block' do
      it 'returns an array containing the minimum n elements' do
        expect(e_ints.min(2) { |a, b| a * 2 <=> b * 2 }).to eql [22, 333]
      end
    end

    context 'on a enumerable of length x where x < n' do
      it 'returns an array containing the minimum n elements of length x' do
        expect(e_ints.min(500).length).to eql e_ints.length
      end
    end

    context 'that is negative' do
      it 'raises an ArgumentError' do
        expect { e_ints.min(-1) }.to raise_error(ArgumentError, 'negative size (-1)')
      end
    end
  end

  context 'that is nil' do
    it 'returns the minimum element' do
      expect(e_ints.min(nil)).to eql 22
    end
  end
end
