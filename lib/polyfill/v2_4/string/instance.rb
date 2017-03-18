require 'polyfill/v2_4/string/instance/concat'
require 'polyfill/v2_4/string/instance/prepend'

module Polyfill
  module V2_4
    module String
      module Instance
        include Concat
        include Prepend
      end
    end
  end
end
