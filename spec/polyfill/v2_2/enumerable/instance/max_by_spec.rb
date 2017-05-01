RSpec.describe 'Enumerable#max_by' do
  using Polyfill(Enumerable: %w[#max_by])

  it 'returns an enumerator if no block' do
    expect([42].max_by).to be_an_instance_of(Enumerator)
  end

  it 'returns nil if #each yields no objects' do
    expect([].max_by(&:nonesuch)).to be nil
  end

  it 'returns the object for whom the value returned by block is the largest' do
    expect(%w[1 2 3].max_by(&:to_i)).to eql '3'
    expect(%w[three five].max_by(&:length)).to eql 'three'
  end

  it 'returns the object that appears first in #each in case of a tie' do
    obj = '2'
    expect(['1', obj, '2'].max_by(&:to_i)).to be obj
  end

  it 'uses max.<=>(current) to determine order' do
    klass = Class.new do
      include Comparable
      def initialize(num)
        @num = num
      end

      attr_accessor :num

      # Reverse comparison
      def <=>(other)
        other.num <=> @num
      end
    end
    a = [klass.new(1), klass.new(2), klass.new(3)]
    # Just using self here to avoid additional complexity
    expect(a.max_by { |o| o }).to eql a[0]
  end

  it 'is able to return the maximum for enums that contain nils' do
    enum = [nil, nil, true]
    expect(enum.max_by { |o| o.nil? ? 0 : 1 }).to be true
    expect(enum.max_by { |o| o.nil? ? 1 : 0 }).to be nil
  end

  it 'gathers whole arrays as elements when each yields multiple' do
    obj = Class.new do
      include Enumerable
      include Polyfill.get(:Enumerable, %i[max_by])

      def each
        yield 1, 2
        yield 3, 4, 5
        yield 6, 7, 8, 9
      end
    end.new

    expect(obj.max_by(&:size)).to eql [6, 7, 8, 9]
  end

  context 'enumerable with size' do
    it 'returns the size' do
      expect([1, 2, 3].max_by.size).to eql 3
    end
  end

  context 'enumerable without size' do
    it 'returns nil' do
      obj = Class.new do
        include Enumerable
        include Polyfill.get(:Enumerable, %i[max_by])

        def each
          3.times { |n| yield n }
        end
      end.new

      expect(obj.max_by.size).to eql nil
    end
  end

  context 'when called with an argument n' do
    let(:enum) { [101, 55, 1, 20, 33, 500, 60] }

    context 'without a block' do
      it 'returns an enumerator' do
        expect(enum.max_by(2)).to be_an_instance_of(Enumerator)
      end
    end

    context 'with a block' do
      it "returns an array containing the maximum n elements based on the block's value" do
        expect(enum.max_by(3, &:to_s)).to eql [60, 55, 500]
      end

      context 'on a enumerable of length x where x < n' do
        it 'returns an array containing the maximum n elements of length n' do
          expect(enum.max_by(500, &:to_s).length).to eql enum.length
        end
      end

      context 'when n is negative' do
        it 'raises an ArgumentError' do
          expect do
            enum.max_by(-1, &:to_s)
          end.to raise_error(ArgumentError, 'negative size (-1)')
        end
      end
    end

    context 'when n is nil' do
      it 'returns the maximum element' do
        expect(enum.max_by(nil, &:to_s)).to eql 60
      end
    end
  end
end
