require_relative 'instance/compact'
require_relative 'instance/compact_e'
require_relative 'instance/transform_values'
require_relative 'instance/transform_values_e'

module Polyfill
  module V2_4
    module Hash
      module Instance
        include Compact
        include CompactE
        include TransformValues
        include TransformValuesE
      end
    end
  end
end
