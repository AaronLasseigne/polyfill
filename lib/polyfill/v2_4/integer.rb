require 'polyfill/v2_4/integer/ceil'
require 'polyfill/v2_4/integer/digits'
require 'polyfill/v2_4/integer/floor'

module Polyfill
  module V2_4
    module Integer
      include Ceil
      include Digits
      include Floor
    end
  end
end
