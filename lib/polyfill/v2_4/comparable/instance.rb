require_relative 'instance/clamp'

module Polyfill
  module V2_4
    module Comparable
      module Instance
        include Clamp
      end
    end
  end
end
