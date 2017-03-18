require 'polyfill/v2_4/float/instance/ceil'
require 'polyfill/v2_4/float/instance/floor'
require 'polyfill/v2_4/float/instance/truncate'

module Polyfill
  module V2_4
    module Float
      module Instance
        include Ceil
        include Floor
        include Truncate
      end
    end
  end
end
