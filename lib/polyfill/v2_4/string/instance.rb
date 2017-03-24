require_relative 'instance/casecmp_q'
require_relative 'instance/concat'
require_relative 'instance/each_line'
require_relative 'instance/lines'
require_relative 'instance/match_q'
require_relative 'instance/prepend'
require_relative 'instance/unpack1'

module Polyfill
  module V2_4
    module String
      module Instance
        include CasecmpQ
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
