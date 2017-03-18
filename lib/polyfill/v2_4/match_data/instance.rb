require 'polyfill/v2_4/match_data/instance/named_captures'
require 'polyfill/v2_4/match_data/instance/values_at'

module Polyfill
  module V2_4
    module MatchData
      module Instance
        include NamedCaptures
        include ValuesAt
      end
    end
  end
end
