require 'polyfill/v2_4/float/ceil'
require 'polyfill/v2_4/float/floor'
require 'polyfill/v2_4/float/truncate'

module Polyfill
  module V2_4
    module Float
      include Ceil
      include Floor
      include Truncate
    end
  end
end
