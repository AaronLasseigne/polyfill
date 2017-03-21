require_relative 'instance/uniq'

module Polyfill
  module V2_4
    module Enumerator
      module Lazy
        module Instance
          include Uniq
        end
      end
    end
  end
end
