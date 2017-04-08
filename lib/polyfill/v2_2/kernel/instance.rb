require_relative 'instance/itself'

module Polyfill
  module V2_2
    module Kernel
      module Instance
        include Itself
      end
    end
  end
end
