RSpec.describe 'String#casecmp?' do
  using Polyfill(String: %w[#casecmp?], version: '2.5')

  it "returns nil if other can't be converted to a string" do
    expect('abc'.casecmp?(1)).to be nil
  end
end
