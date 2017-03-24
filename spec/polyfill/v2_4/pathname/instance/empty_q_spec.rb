require 'pathname'

RSpec.describe 'Pathname#empty?' do
  using Polyfill(Pathname: %w[#empty?])

  def fixture(file_name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  before(:all) { Dir.mkdir(fixture('empty')) }
  after(:all) { Dir.rmdir(fixture('empty')) }

  it 'returns true if the path is a directory and has no content' do
    expect(Pathname.new(fixture('empty')).empty?).to be true
  end

  it 'returns false when the path is a directory and has content' do
    expect(Pathname.new(fixture('non-empty')).empty?).to be false
  end

  it 'returns false when the path is a directory and does not exist' do
    expect(Pathname.new(fixture('missing')).empty?).to be false
  end

  it 'returns true if the file exists and is has zero size' do
    expect(Pathname.new(fixture('non-empty/empty.txt')).empty?).to be true
  end

  it 'returns false if the file exists and is has more than a zero size' do
    expect(Pathname.new(fixture('non-empty/non-empty.txt')).empty?).to be false
  end

  it 'returns false if the path does not exist' do
    expect(Pathname.new(fixture('missing.txt')).empty?).to be false
  end
end
