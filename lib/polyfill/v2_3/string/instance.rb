require_relative 'instance/plus_unary'
require_relative 'instance/minus_unary'

module Polyfill
  module V2_3
    module String
      module Instance
        include PlusUnary
        include MinusUnary
      end
    end
  end
end
