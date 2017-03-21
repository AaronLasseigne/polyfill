RSpec.describe 'Enumerable#sum' do
  using Polyfill(Enumerable: %w[#sum])

  def fixture(file_name = '')
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  it 'sums the elements with an initial value (default 0)' do
    expect(Dir.new(fixture).sum('')).to eql '...file.txt'
    expect(
      Enumerator.new do |y|
        y << 1
        y << 2
      end.sum
    ).to eql 3
    expect(
      { one: 1, two: 2, three: 3 }.sum([])
    ).to eql [:one, 1, :two, 2, :three, 3]
    expect(
      IO.new(IO.sysopen(fixture('file.txt'))).sum('')
    ).to eql "line 1\nline 2\n"
    expect((1..3).sum).to eql 6
    expect(StringIO.new('abc').sum('')).to eql 'abc'
    expect(Struct.new(:one, :two).new(1, 2).sum).to eql 3
  end

  it 'will take a block and add the result' do
    expect((1..3).sum { |n| n * 2 }).to eql 12
  end

  it 'does not modify the object passed' do
    init = ''
    expect(('a'..'c').sum(init)).to eql 'abc'
    expect(init).to eql ''

    init = ''.freeze
    expect(('a'..'c').sum(init)).to eql 'abc'
    expect(init).to eql ''
  end

  it 'uses each' do
    klass = Class.new do
      include Enumerable
      include Polyfill(Enumerable: %w[#sum])

      def each
        if block_given?
          %w[a b c].reverse_each(&Proc.new)
        else
          %w[a b c].reverse_each
        end
      end
    end
    expect(klass.new.sum('')).to eql 'cba'
  end
end
