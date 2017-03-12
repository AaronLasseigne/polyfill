require 'polyfill/v2_4/integer/ceil'
require 'polyfill/v2_4/integer/digits'

module Polyfill
  module V2_4
    module Integer
      include Ceil
      include Digits
    end
  end
end
