require_relative 'instance/named_captures'
require_relative 'instance/values_at'

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
