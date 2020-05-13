require 'matrix'

RSpec.describe 'Matrix#collect' do
  using Polyfill(Matrix: %w[#collect], version: '2.6')

  it 'returns a new matrix by applying an operation to the elements' do
    x = Matrix[[1, 2], [3, 4]]
    expect(x.collect { |e| 2 * e }).to eql Matrix[[2, 4], [6, 8]]
  end

  it 'accepts :diagonal as argument' do
    x = Matrix[[1, 2], [3, 4]]
    expect(x.collect(:diagonal) { |e| 2 * e }).to eql Matrix[[2, 2], [3, 8]]
  end

  it 'accepts :off_diagonal as argument' do
    x = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    expect(x.collect(:off_diagonal) { |e| 3 * e }).to eql Matrix[[1, 6, 9], [12, 5, 18], [21, 24, 9]]
  end

  it 'accepts :lower as argument' do
    x = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    expect(x.collect(:lower) { |e| 3 * e }).to eql Matrix[[3, 2, 3], [12, 15, 6], [21, 24, 27]]
  end

  it 'accepts :strict_lower as argument' do
    x = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    expect(x.collect(:strict_lower) { |e| 3 * e }).to eql Matrix[[1, 2, 3], [12, 5, 6], [21, 24, 9]]
  end

  it 'accepts :strict_upper as argument' do
    x = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    expect(x.collect(:strict_upper) { |e| e**2 }).to eql Matrix[[1, 4, 9], [4, 5, 36], [7, 8, 9]]
  end

  it 'accepts :upper as argument' do
    x = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    expect(x.collect(:upper) { |e| e**2 }).to eql Matrix[[1, 4, 9], [4, 25, 36], [7, 8, 81]]
  end

  it 'throws an error when argument is invalid' do
    x = Matrix[[1, 2], [3, 4]]
    expect { x.collect(:nonsense) { |e| 2 * e } }.to raise_error(ArgumentError)
  end
end
