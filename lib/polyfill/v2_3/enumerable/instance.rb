require_relative 'instance/chunk_while'
require_relative 'instance/grep_v'

module Polyfill
  module V2_3
    module Enumerable
      module Instance
        include ChunkWhile
        include GrepV
      end
    end
  end
end
