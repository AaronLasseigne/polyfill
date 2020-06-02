require 'matrix'

RSpec.describe 'Matrix#antisymmetric?' do
  using Polyfill(Matrix: %w[#antisymmetric?], version: '2.6')

  it 'returns true when antisymmetric' do
    x = Matrix[[0, -1], [1, 0]]
    expect(x.antisymmetric?).to eql true
  end

  it 'returns false when not antisymmetric' do
    x = Matrix[[1, 0], [0, 1]]
    expect(x.antisymmetric?).to eql false
  end

  it "raises a #{matrix_dimension_mismatch_error_class} when not square" do
    x = Matrix[[0, 1]]
    expect { x.antisymmetric? }.to raise_error(matrix_dimension_mismatch_error_class, 'Matrix dimension mismatch')
  end
end
