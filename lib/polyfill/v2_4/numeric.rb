require 'polyfill/v2_4/numeric/finite__q'
require 'polyfill/v2_4/numeric/infinite__q'

module Polyfill
  module V2_4
    module Numeric
      include Finite__Q
      include Infinite__Q
    end
  end
end
