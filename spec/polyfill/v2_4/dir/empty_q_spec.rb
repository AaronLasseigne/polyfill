RSpec.describe 'Dir.empty?' do
  using Polyfill::V2_4::Dir::EmptyQ

  def file(file_name)
    File.join(File.dirname(__FILE__), 'fixtures', file_name)
  end

  it 'returns true if the file is a directory and has no content' do
    dir = file('empty')
    Dir.mkdir(dir) unless Dir.exist?(dir)

    expect(Dir.empty?(dir)).to be true

    Dir.rmdir(dir)
  end

  it 'returns false when the file is a directory and has content' do
    expect(Dir.empty?(file('non-empty'))).to be false
  end

  it 'returns false if the file is not a directory' do
    expect(Dir.empty?(file('non-empty/file.txt'))).to be false
  end
end
