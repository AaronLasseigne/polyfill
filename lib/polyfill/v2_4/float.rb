require 'polyfill/v2_4/float/ceil'
require 'polyfill/v2_4/float/floor'

module Polyfill
  module V2_4
    module Float
      include Ceil
      include Floor
    end
  end
end
