require 'polyfill/v2_4/symbol/instance/match_q'
require 'polyfill/v2_4/symbol/instance/match'

module Polyfill
  module V2_4
    module Symbol
      module Instance
        include Match
        include MatchQ
      end
    end
  end
end
