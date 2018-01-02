RSpec.describe 'Enumerator::Lazy#grep_v' do
  using Polyfill(:'Enumerator::Lazy' => %w[#grep_v], version: '2.3')

  let(:yieldsmixed) { [nil, 0, nil, :default_arg, [], [], [0], [0, 1], [0, 1, 2]].to_enum.lazy }

  # it 'requires an argument' do
  #   expect(Enumerator::Lazy.instance_method(:grep_v).arity).to eql 1
  # end

  it 'returns a new instance of Enumerator::Lazy' do
    ret = yieldsmixed.grep_v(Object) {}
    expect(ret).to be_an_instance_of(Enumerator::Lazy)
    expect(ret).to_not equal yieldsmixed

    ret = yieldsmixed.grep_v(Object)
    expect(ret).to be_an_instance_of(Enumerator::Lazy)
    expect(ret).to_not equal yieldsmixed
  end

  it 'sets #size to nil' do
    expect(Enumerator::Lazy.new(Object.new, 100) {}.grep_v(Object) {}.size).to eql nil
    expect(Enumerator::Lazy.new(Object.new, 100) {}.grep_v(Object).size).to eql nil
  end

  describe 'when the returned lazy enumerator is evaluated by Enumerable#first' do
    it 'stops after specified times when not given a block' do
      expect((0..Float::INFINITY).lazy.grep_v(3..5).first(3)).to eql [0, 1, 2]
    end

    it 'stops after specified times when given a block' do
      expect((0..Float::INFINITY).lazy.grep_v(4..8, &:succ).first(3)).to eql [1, 2, 3]
    end
  end

  it 'calls the block with a gathered array when yield with multiple arguments' do
    yields = []
    yieldsmixed.grep_v(Array) { |v| yields << v }.force
    expect(yields).to eql [nil, 0, nil, :default_arg]

    expect(yieldsmixed.grep_v(Array).force).to eql yields
  end

  describe 'on a nested Lazy' do
    it 'sets #size to nil' do
      expect(Enumerator::Lazy.new(Object.new, 100) {}.grep_v(Object).grep_v(Object) {}.size).to eql nil
      expect(Enumerator::Lazy.new(Object.new, 100) {}.grep_v(Object).grep_v(Object).size).to eql nil
    end

    describe 'when the returned lazy enumerator is evaluated by Enumerable#first' do
      it 'stops after specified times when not given a block' do
        expect((0..Float::INFINITY).lazy.grep_v(3..5).grep_v(6..10).first(3)).to eql [0, 1, 2]
      end

      it 'stops after specified times when given a block' do
        expect(
          (0..Float::INFINITY).lazy
            .grep_v(1..2) { |n| n > 3 ? n : false }
            .grep_v(false) { |n| n.even? ? n : false }
            .first(3)
        ).to eql [4, false, 6]
      end
    end
  end
end
