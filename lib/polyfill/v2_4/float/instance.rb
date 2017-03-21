require_relative 'instance/ceil'
require_relative 'instance/floor'
require_relative 'instance/truncate'

module Polyfill
  module V2_4
    module Float
      module Instance
        include Ceil
        include Floor
        include Truncate
      end
    end
  end
end
