require_relative 'instance/chunk'

module Polyfill
  module V2_4
    module Enumerable
      module Instance
        include Chunk
      end
    end
  end
end
