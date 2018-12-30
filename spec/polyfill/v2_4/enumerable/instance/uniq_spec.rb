RSpec.describe 'Enumerable#uniq' do
  using Polyfill(Enumerable: %w[#uniq], version: '2.4')

  def fixture(file_name = '')
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  it 'uniques the elements' do
    expect(Dir.new(fixture).sort.uniq).to eql %w[. .. file.txt]
    expect(
      Enumerator.new do |y|
        y << 1
        y << 1
      end.uniq
    ).to eql [1]
    expect(
      { one: 1, two: 2, three: 3 }.uniq
    ).to eql [[:one, 1], [:two, 2], [:three, 3]]
    expect(
      IO.new(IO.sysopen(fixture('file.txt'))).uniq
    ).to eql ["line 1\n", "line 2\n"]
    expect((1..3).uniq).to eql [1, 2, 3]
    expect(
      StringIO.new("line 1\nline 2\n").uniq
    ).to eql ["line 1\n", "line 2\n"]
    expect(Struct.new(:one, :two).new(1, 1).uniq).to eql [1]
  end

  it 'will base uniqueness off of the block' do
    expect(Dir.new(fixture).sort.uniq { |file_name| file_name[0] }).to eql %w[. file.txt]
    enum = Enumerator.new do |y|
      y << 1
      y << 2
      y << 3
    end
    expect(
      enum.uniq { |n| n % 2 }
    ).to eql [1, 2]
    expect(
      { one: 1, two: 2, three: 3 }.uniq { |_, v| v % 2 }
    ).to eql [[:one, 1], [:two, 2]]
    expect(
      IO.new(IO.sysopen(fixture('file.txt'))).uniq { |line| line[0] }
    ).to eql ["line 1\n"]
    expect((1..3).uniq { |n| n % 2 }).to eql [1, 2]
    expect(
      StringIO.new("line 1\nline 2\n").uniq { |line| line[0] }
    ).to eql ["line 1\n"]
    expect(
      Struct.new(:one, :two, :three).new(1, 2, 3).uniq { |n| n % 2 }
    ).to eql [1, 2]
  end
end
