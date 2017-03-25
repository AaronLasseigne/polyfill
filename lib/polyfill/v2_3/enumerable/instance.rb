require_relative 'instance/chunk_while'

module Polyfill
  module V2_3
    module Enumerable
      module Instance
        include ChunkWhile
      end
    end
  end
end
