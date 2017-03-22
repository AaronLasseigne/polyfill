require_relative 'instance/clone'

module Polyfill
  module V2_4
    module Object
      module Instance
        include Clone
      end
    end
  end
end
