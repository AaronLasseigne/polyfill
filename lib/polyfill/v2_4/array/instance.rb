require_relative 'instance/concat'
require_relative 'instance/sum'

module Polyfill
  module V2_4
    module Array
      module Instance
        include Concat
        include Sum
      end
    end
  end
end
