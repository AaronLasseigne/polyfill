require_relative 'instance/chunk'
require_relative 'instance/sum'
require_relative 'instance/uniq'

module Polyfill
  module V2_4
    module Enumerable
      module Instance
        include Chunk
        include Sum
        include Uniq
      end
    end
  end
end
