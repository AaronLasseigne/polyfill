require_relative 'instance/ceil'
require_relative 'instance/digits'
require_relative 'instance/floor'
require_relative 'instance/round'
require_relative 'instance/truncate'

module Polyfill
  module V2_4
    module Integer
      module Instance
        include Ceil
        include Digits
        include Floor
        include Round
        include Truncate
      end
    end
  end
end
