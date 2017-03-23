require_relative 'instance/equalequal'
require_relative 'instance/lessthanequalgreaterthan'

module Polyfill
  module V2_4
    module IPAddr
      module Instance
        include Equalequal
        include Lessthanequalgreaterthan
      end
    end
  end
end
