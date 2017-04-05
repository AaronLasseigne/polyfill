require_relative 'instance/chunk_while'
require_relative 'instance/grep_v'
require_relative 'instance/slice_before'

module Polyfill
  module V2_3
    module Enumerable
      module Instance
        include ChunkWhile
        include GrepV
        include SliceBefore
      end
    end
  end
end
