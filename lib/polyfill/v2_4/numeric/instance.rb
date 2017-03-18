require 'polyfill/v2_4/numeric/instance/finite_q'
require 'polyfill/v2_4/numeric/instance/infinite_q'

module Polyfill
  module V2_4
    module Numeric
      module Instance
        include FiniteQ
        include InfiniteQ
      end
    end
  end
end
