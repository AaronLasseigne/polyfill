require_relative 'instance/chunk'
require_relative 'instance/sum'

module Polyfill
  module V2_4
    module Enumerable
      module Instance
        include Chunk
        include Sum
      end
    end
  end
end
