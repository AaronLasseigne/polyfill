require_relative 'instance/casecmp_q'
require_relative 'instance/match_q'
require_relative 'instance/match'

module Polyfill
  module V2_4
    module Symbol
      module Instance
        include CasecmpQ
        include Match
        include MatchQ
      end
    end
  end
end
