RSpec.describe 'Enumerable#min_by' do
  using Polyfill(Enumerable: %w[#min_by])

  it 'returns an enumerator if no block' do
    expect([42].min_by).to be_an_instance_of(Enumerator)
  end

  it 'returns nil if #each yields no objects' do
    expect([].min_by(&:nonesuch)).to eql nil
  end

  it 'returns the object for whom the value returned by block is the smallest' do
    expect(%w[3 2 1].min_by(&:to_i)).to eql '1'
    expect(%w[five three].min_by(&:length)).to eql 'five'
  end

  it 'returns the object that appears first in #each in case of a tie' do
    obj = '1'
    expect(['2', obj, '1'].min_by(&:to_i)).to be obj
  end

  it 'uses min.<=>(current) to determine order' do
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
    expect(a.min_by { |o| o }).to eql a[-1]
  end

  it 'is able to return the minimum for enums that contain nils' do
    enum = [nil, nil, true]
    expect(enum.min_by { |o| o.nil? ? 0 : 1 }).to eql nil
    expect(enum.min_by { |o| o.nil? ? 1 : 0 }).to eql true
  end

  it 'gathers whole arrays as elements when each yields multiple' do
    obj = Class.new do
      include Enumerable
      include Polyfill.get(:Enumerable, %i[min_by])

      def each
        yield 1, 2
        yield 3, 4, 5
        yield 6, 7, 8, 9
      end
    end.new

    expect(obj.min_by(&:size)).to eql [1, 2]
  end

  context 'enumerable with size' do
    it 'returns the size' do
      expect([1, 2, 3].min_by.size).to eql 3
    end
  end

  context 'enumerable without size' do
    it 'returns nil' do
      obj = Class.new do
        include Enumerable
        include Polyfill.get(:Enumerable, %i[min_by])

        def each
          3.times { |n| yield n }
        end
      end.new

      expect(obj.min_by.size).to eql nil
    end
  end

  context 'when called with an argument n' do
    let(:enum) { [101, 55, 1, 20, 33, 500, 60] }

    context 'without a block' do
      it 'returns an enumerator' do
        expect(enum.min_by(2)).to be_an_instance_of(Enumerator)
      end
    end

    context 'with a block' do
      it "returns an array containing the minimum n elements based on the block's value" do
        expect(enum.min_by(3, &:to_s)).to eql [1, 101, 20]
      end

      context 'on a enumerable of length x where x < n' do
        it 'returns an array containing the minimum n elements of length n' do
          expect(enum.min_by(500, &:to_s).length).to eql enum.length
        end
      end

      context 'when n is negative' do
        it 'raises an ArgumentError' do
          expect do
            enum.min_by(-1, &:to_s)
          end.to raise_error(ArgumentError, 'negative size (-1)')
        end
      end
    end

    context 'when n is nil' do
      it 'returns the minimum element' do
        expect(enum.min_by(nil, &:to_s)).to eql 1
      end
    end
  end
end
