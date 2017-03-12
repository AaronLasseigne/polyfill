require 'polyfill/v2_4/string/concat'
require 'polyfill/v2_4/string/prepend'

module Polyfill
  module V2_4
    module String
      include Concat
      include Prepend
    end
  end
end
