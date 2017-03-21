require_relative 'instance/concat'

module Polyfill
  module V2_4
    module Array
      module Instance
        include Concat
      end
    end
  end
end
