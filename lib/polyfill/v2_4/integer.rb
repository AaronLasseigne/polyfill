require 'polyfill/v2_4/integer/ceil'
require 'polyfill/v2_4/integer/digits'
require 'polyfill/v2_4/integer/floor'
require 'polyfill/v2_4/integer/round'
require 'polyfill/v2_4/integer/truncate'

module Polyfill
  module V2_4
    module Integer
      include Ceil
      include Digits
      include Floor
      include Round
      include Truncate
    end
  end
end
