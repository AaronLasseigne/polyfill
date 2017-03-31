RSpec.describe 'String#+@' do
  using Polyfill(String: %w[#+@])

  def fixture(file_name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', file_name)
  end

  it 'returns an unfrozen copy of a frozen String' do
    input  = 'foo'.freeze
    output = +input

    expect(output.frozen?).to be false
    expect(output).to eql 'foo'
  end

  it 'returns self if the String is not frozen' do
    input  = 'foo'
    output = +input

    expect(output).to be input
  end

  it 'returns mutable copy despite freeze-magic-comment in file' do
    expect(`ruby -I ../../../lib #{fixture('freeze_magic_comment.rb')}`).to eql 'mutable'
  end
end
