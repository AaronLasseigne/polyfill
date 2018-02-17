RSpec.describe 'String#start_with?' do
  using Polyfill(String: %w[#start_with?], version: '2.5')

  it 'supports regexps' do
    regexp = /[h1]/

    expect('hello'.start_with?(regexp)).to be true
    expect('1337'.start_with?(regexp)).to be true
    expect('foxes are 1337'.start_with?(regexp)).to be false
    expect("chunky\n12bacon".start_with?(/12/)).to be false

    expect('hello'.start_with?('a', regexp)).to be true
    expect('foxes are 1337'.start_with?('a', regexp)).to be false
  end

  it 'supports regexps with ^ and $ modifiers' do
    regexp1 = /^\d{2}/
    regexp2 = /\d{2}$/

    expect('12test'.start_with?(regexp1)).to be true
    expect('test12'.start_with?(regexp1)).to be false
    expect('12test'.start_with?(regexp2)).to be false
    expect('test12'.start_with?(regexp2)).to be false
  end

  it 'sets Regexp.last_match if it returns true' do
    regexp = /test-(\d+)/

    expect('test-1337'.start_with?(regexp)).to be true
    when_ruby_above('2.4') do
      expect(Regexp.last_match).to_not be_nil
      expect(Regexp.last_match[1]).to eql '1337'
      expect($1).to eql '1337' # rubocop:disable Style/PerlBackrefs
    end

    expect('test-asdf'.start_with?(regexp)).to be false
    when_ruby_above('2.4') do
      expect(Regexp.last_match).to be_nil
      expect($1).to be_nil # rubocop:disable Style/PerlBackrefs
    end
  end
end
