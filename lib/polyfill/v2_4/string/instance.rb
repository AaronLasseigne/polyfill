require 'polyfill/v2_4/string/instance/concat'
require 'polyfill/v2_4/string/instance/each_line'
require 'polyfill/v2_4/string/instance/lines'
require 'polyfill/v2_4/string/instance/match_q'
require 'polyfill/v2_4/string/instance/prepend'
require 'polyfill/v2_4/string/instance/unpack1'

module Polyfill
  module V2_4
    module String
      module Instance
        include Concat
        include EachLine
        include Lines
        include MatchQ
        include Prepend
        include Unpack1
      end
    end
  end
end
