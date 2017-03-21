require_relative 'instance/finite_q'
require_relative 'instance/infinite_q'

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
