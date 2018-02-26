RSpec.describe 'Dir.each_child' do
  using Polyfill(Dir: %w[.each_child], version: '2.5')

  def fixture(name = '')
    File.join(File.dirname(__FILE__), '..', 'fixtures', name)
  end

  it 'yields all names in an existing directory to the provided block' do
    a = []
    b = []

    Dir.each_child(fixture) { |f| a << f }
    Dir.each_child(fixture('/deeply/nested')) { |f| b << f }

    expect(a.sort).to eql %w[deeply special]
    expect(b.sort).to eql %w[.dotfile.ext directory]
  end

  it 'returns nil when successful' do
    expect(Dir.each_child(fixture) { |f| f }).to be nil
  end

  it 'calls #to_path on non-String arguments' do
    p = double('path')
    expect(p).to receive(:to_path).and_return(fixture)

    Dir.each_child(p).to_a
  end

  it 'raises a SystemCallError if passed a nonexistent directory' do
    expect { Dir.each_child(fixture('nonexistent')) {} }.to raise_error(SystemCallError)
  end

  describe 'when no block is given' do
    it 'returns an Enumerator' do
      expect(Dir.each_child(fixture)).to be_an_instance_of(Enumerator)
      expect(Dir.each_child(fixture).to_a.sort).to eql %w[deeply special]
    end

    describe 'returned Enumerator' do
      describe 'size' do
        it 'returns nil' do
          expect(Dir.each_child(fixture).size).to eql nil
        end
      end
    end
  end
end
