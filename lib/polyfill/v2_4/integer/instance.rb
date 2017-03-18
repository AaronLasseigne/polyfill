require 'polyfill/v2_4/integer/instance/ceil'
require 'polyfill/v2_4/integer/instance/digits'
require 'polyfill/v2_4/integer/instance/floor'
require 'polyfill/v2_4/integer/instance/round'
require 'polyfill/v2_4/integer/instance/truncate'

module Polyfill
  module V2_4
    module Integer
      module Instance
        include Ceil
        include Digits
        include Floor
        include Round
        include Truncate
      end
    end
  end
end
