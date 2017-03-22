require_relative 'instance/clone'
require_relative 'instance/dup'
require_relative 'instance/finite_q'
require_relative 'instance/infinite_q'

module Polyfill
  module V2_4
    module Numeric
      module Instance
        include Dup
        include Clone
        include FiniteQ
        include InfiniteQ
      end
    end
  end
end
