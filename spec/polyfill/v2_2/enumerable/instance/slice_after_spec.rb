RSpec.describe 'Enumerable#slice_after' do
  using Polyfill(Enumerable: %w[#slice_after])

  before :each do
    @enum = (1..7).to_a.reverse
  end

  context 'when given an argument and no block' do
    it 'calls === on the argument to determine when to yield' do
      arg = double('filter')
      expect(arg).to receive(:===).and_return(false, true, false, false, false, true, false)
      e = @enum.slice_after(arg)
      expect(e).to be_an_instance_of(Enumerator)
      expect(e.to_a).to eql [[7, 6], [5, 4, 3, 2], [1]]
    end

    it "doesn't yield an empty array if the filter matches the first entry or the last entry" do
      arg = double('filter')
      expect(arg).to receive(:===).and_return(true).exactly(7)
      e = @enum.slice_after(arg)
      expect(e.to_a).to eql [[7], [6], [5], [4], [3], [2], [1]]
    end

    it 'uses standard boolean as a test' do
      arg = double('filter')
      expect(arg).to receive(:===).and_return(false, :foo, nil, false, false, 42, false)
      e = @enum.slice_after(arg)
      expect(e.to_a).to eql [[7, 6], [5, 4, 3, 2], [1]]
    end
  end

  context 'when given a block' do
    context 'and no argument' do
      it 'calls the block to determine when to yield' do
        e = @enum.slice_after { |i| i == 6 || i == 2 }
        expect(e).to be_an_instance_of(Enumerator)
        expect(e.to_a).to eql [[7, 6], [5, 4, 3, 2], [1]]
      end
    end

    context 'and an argument' do
      it 'raises an ArgumentError' do
        when_ruby('2.2') do
          expect do
            @enum.slice_after(42) { |i| i == 6 }
          end.to raise_error(ArgumentError, 'both pattan and block are given')
        end
        when_ruby_above('2.2') do
          expect do
            @enum.slice_after(42) { |i| i == 6 }
          end.to raise_error(ArgumentError, 'both pattern and block are given')
        end
      end
    end
  end

  it 'raises an ArgumentError when given an incorrect number of arguments' do
    expect { @enum.slice_after('one', 'two') }.to raise_error(ArgumentError)
    when_ruby('2.2') do
      expect do
        @enum.slice_after
      end.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1)')
    end
    when_ruby_above('2.2') do
      expect do
        @enum.slice_after
      end.to raise_error(ArgumentError, 'wrong number of arguments (given 0, expected 1)')
    end
  end

  context 'when an iterator method yields more than one value' do
    it 'processes all yielded values' do
      enum = Class.new do
        include Enumerable
        include Polyfill.get(:Enumerable, %i[slice_after])

        def each
          yield 1, 2
          yield 3, 4, 5
          yield 6, 7, 8, 9
        end
      end.new
      result = enum.slice_after { |i| i == [3, 4, 5] }.to_a
      expect(result).to eql [[[1, 2], [3, 4, 5]], [[6, 7, 8, 9]]]
    end

    it 'processes all yielded values' do
      def foo
        yield 1, 2
        yield 3, 4
      end
      expect(to_enum(:foo).slice_after { false }.to_a).to eql [[[1, 2], [3, 4]]]
    end
  end

  context 'with #lazy' do
    it 'works' do
      expect(
        (1..Float::INFINITY)
          .lazy
          .slice_after { |a| a % 3 == 0 }
          .first(3)
      ).to eql [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    end
  end
end
