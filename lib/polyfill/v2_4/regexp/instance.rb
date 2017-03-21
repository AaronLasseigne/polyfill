require_relative 'instance/match_q'

module Polyfill
  module V2_4
    module Regexp
      module Instance
        include MatchQ
      end
    end
  end
end
