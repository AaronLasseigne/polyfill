require 'matrix'

RSpec.describe 'Matrix#skew_symmetric?' do
  using Polyfill(Matrix: %w[#skew_symmetric?], version: '2.6')

  it 'returns true when skew symmetric' do
    x = Matrix[[0, -1], [1, 0]]
    expect(x.skew_symmetric?).to eql true
  end

  it 'returns false when not skew symmetric' do
    x = Matrix[[1, 0], [0, 1]]
    expect(x.skew_symmetric?).to eql false
  end

  it "raises a #{matrix_dimension_mismatch_error_class} when not square" do
    x = Matrix[[0, 1]]
    expect { x.skew_symmetric? }.to raise_error(matrix_dimension_mismatch_error_class, 'Matrix dimension mismatch')
  end
end
