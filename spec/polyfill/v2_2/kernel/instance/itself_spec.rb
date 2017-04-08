RSpec.describe 'Kernel#itself' do
  using Polyfill(Kernel: %w[#itself])

  it 'returns the receiver itself' do
    foo = Object.new
    expect(foo.itself).to be foo
  end
end
