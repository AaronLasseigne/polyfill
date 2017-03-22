RSpec.describe 'Dir.empty?' do
  using Polyfill(Dir: %w[.empty?])

  def fixture(file_name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  before(:all) { Dir.mkdir(fixture('empty')) }
  after(:all) { Dir.rmdir(fixture('empty')) }

  it 'returns true if the file is a directory and has no content' do
    expect(Dir.empty?(fixture('empty'))).to be true
  end

  it 'returns false when the file is a directory and has content' do
    expect(Dir.empty?(fixture('non-empty'))).to be false
  end

  it 'returns false if the file is not a directory' do
    expect(Dir.empty?(fixture('non-empty/file.txt'))).to be false
  end
end
