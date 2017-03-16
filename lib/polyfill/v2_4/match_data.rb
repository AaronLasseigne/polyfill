require 'polyfill/v2_4/match_data/named_captures'
require 'polyfill/v2_4/match_data/values_at'

module Polyfill
  module V2_4
    module MatchData
      include NamedCaptures
      include ValuesAt
    end
  end
end
