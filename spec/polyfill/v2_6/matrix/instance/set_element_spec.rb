require 'matrix'

RSpec.describe 'Matrix#[]=' do
  using Polyfill(Matrix: %w[#[]=], version: '2.6')

  it 'sets the specific element to the specified value' do
    x = Matrix[[0, 0], [0, 0]]
    x[0, 0] = 1
    x[0, 1] = 1
    expect(x).to eql Matrix[[1, 1], [0, 0]]
  end

  it 'throws an error when matrix is frozen' do
    x = Matrix[[0, 0]].freeze
    expect { x[0, 0] = 1 }.to raise_error(FrozenError, "can't modify frozen Matrix")
  end
end
