RSpec.describe 'Dir.children' do
  using Polyfill(Dir: %w[.children], version: '2.5')

  def fixture(name = '')
    File.join(File.dirname(__FILE__), '..', 'fixtures', name)
  end

  before :each do
    @internal = Encoding.default_internal
  end

  after :each do
    ignore_warnings do
      Encoding.default_internal = @internal
    end
  end

  it 'returns an Array of filenames in an existing directory including dotfiles' do
    a = Dir.children(fixture('/deeply/nested')).sort
    expect(a).to eql %w[.dotfile.ext directory]
  end

  it 'calls #to_path on non-String arguments' do
    p = double('path')
    expect(p).to receive(:to_path).and_return(fixture)

    Dir.children(p)
  end

  it 'accepts an options Hash' do
    a = Dir.children(fixture('/deeply/nested'), encoding: 'utf-8').sort
    expect(a).to eql %w[.dotfile.ext directory]
  end

  it 'returns children encoded with the filesystem encoding by default' do
    children = Dir.children(fixture('special')).sort
    expect(children.first.encoding).to be Encoding.find('filesystem')
  end

  it 'returns children encoded with the specified encoding' do
    children = Dir.children(fixture('special'), encoding: 'euc-jp').sort

    expect(children.first.encoding).to be Encoding::EUC_JP
  end

  it 'returns children transcoded to the default internal encoding' do
    ignore_warnings do
      Encoding.default_internal = Encoding::EUC_KR
    end
    children = Dir.children(fixture('special')).sort

    expect(children.first.encoding).to be Encoding::EUC_KR
  end

  it 'raises a SystemCallError if called with a nonexistent diretory' do
    expect { Dir.children(fixture('nonexistent')) }.to raise_error(SystemCallError)
  end
end
