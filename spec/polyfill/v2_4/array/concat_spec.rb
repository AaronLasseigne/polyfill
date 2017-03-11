RSpec.describe 'Array#concat' do
  using Polyfill::V2_4::Array::Concat

  context 'existing behavior' do
    it 'returns the array itself' do
      ary = [1, 2, 3]
      expect(ary.concat([4, 5, 6]).equal?(ary)).to be true
    end

    it 'appends the elements in the other array' do
      ary = [1, 2, 3]
      expect(ary.concat([9, 10, 11])).to equal(ary)
      expect(ary).to eql [1, 2, 3, 9, 10, 11]
      ary.concat([])
      expect(ary).to eql [1, 2, 3, 9, 10, 11]
    end

    it 'does not loop endlessly when argument is self' do
      ary = ['x', 'y']
      expect(ary.concat(ary)).to eql ['x', 'y', 'x', 'y']
    end

    it 'tries to convert the passed argument to an Array using #to_ary' do
      obj = double('to_ary')
      allow(obj).to receive(:to_ary).and_return(['x', 'y'])
      expect([4, 5, 6].concat(obj)).to eql [4, 5, 6, 'x', 'y']
    end

    it 'does not call #to_ary on Array subclasses' do
      klass = Class.new(Array) do
        def to_ary() ["to_ary", "was", "called!"] end
      end
      obj = klass.new([5, 6, 7])
      expect(obj).to_not receive(:to_ary)
      expect([].concat(obj)).to eql [5, 6, 7]
    end

    it 'raises a RuntimeError when Array is frozen and modification occurs' do
      expect { [1, 2, 3].freeze.concat [1] }.to raise_error(RuntimeError)
    end

    # see [ruby-core:23666]
    it 'raises a RuntimeError when Array is frozen and no modification occurs' do
      expect { [1, 2, 3].freeze.concat([]) }.to raise_error(RuntimeError)
    end

    it 'keeps tainted status' do
      ary = [1, 2]
      ary.taint
      ary.concat([3])
      expect(ary.tainted?).to be true
      ary.concat([])
      expect(ary.tainted?).to be true
    end

    it 'is not infected by the other' do
      ary = [1, 2]
      other = [3]; other.taint
      expect(ary.tainted?).to be false
      ary.concat(other)
      expect(ary.tainted?).to be false
    end

    it 'keeps the tainted status of elements' do
      ary = [Object.new, Object.new, Object.new]
      ary.each(&:taint)

      ary.concat([Object.new])
      expect(ary[0].tainted?).to be true
      expect(ary[1].tainted?).to be true
      expect(ary[2].tainted?).to be true
      expect(ary[3].tainted?).to be false
    end

    it 'keeps untrusted status' do
      ary = [1, 2]
      ary.untrust
      ary.concat([3])
      expect(ary.untrusted?).to be true
      ary.concat([])
      expect(ary.untrusted?).to be true
    end

    it 'is not infected untrustedness by the other' do
      ary = [1, 2]
      other = [3]; other.untrust
      expect(ary.untrusted?).to be false
      ary.concat(other)
      expect(ary.untrusted?).to be false
    end

    it 'keeps the untrusted status of elements' do
      ary = [Object.new, Object.new, Object.new]
      ary.each(&:untrust)

      ary.concat([Object.new])
      expect(ary[0].untrusted?).to be true
      expect(ary[1].untrusted?).to be true
      expect(ary[2].untrusted?).to be true
      expect(ary[3].untrusted?).to be false
    end

    it 'appends elements to an Array with enough capacity that has been shifted' do
      ary = [1, 2, 3, 4, 5]
      2.times { ary.shift }
      2.times { ary.pop }
      expect(ary.concat([5, 6])).to eql [3, 5, 6]
    end

    it 'appends elements to an Array without enough capacity that has been shifted' do
      ary = [1, 2, 3, 4]
      3.times { ary.shift }
      expect(ary.concat([5, 6])).to eql [4, 5, 6]
    end
  end

  context '2.4' do
    it 'takes multiple arguments' do
      ary = [1, 2]
      ary.concat [3, 4]
      expect(ary).to eql [1, 2, 3, 4]
    end

    it 'concatenates the initial value when given arguments contain 2 self' do
      ary = [1, 2]
      ary.concat ary, ary
      expect(ary).to eql [1, 2, 1, 2, 1, 2]
    end

    it 'returns self when given no arguments' do
      ary = [1, 2]
      expect(ary.concat).to equal(ary)
      expect(ary).to eql [1, 2]
    end
  end
end
