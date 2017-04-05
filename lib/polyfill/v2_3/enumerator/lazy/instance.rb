require_relative 'instance/grep_v'

module Polyfill
  module V2_3
    module Enumerator
      module Lazy
        module Instance
          include GrepV
        end
      end
    end
  end
end
