require 'polyfill/v2_4/numeric/finite_q'
require 'polyfill/v2_4/numeric/infinite_q'

module Polyfill
  module V2_4
    module Numeric
      include FiniteQ
      include InfiniteQ
    end
  end
end
