require_relative 'instance/chunk_while'
require_relative 'instance/uniq'

module Polyfill
  module V2_4
    module Enumerator
      module Lazy
        module Instance
          include ChunkWhile
          include Uniq
        end
      end
    end
  end
end
