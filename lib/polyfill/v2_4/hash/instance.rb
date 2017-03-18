require 'polyfill/v2_4/hash/instance/compact'
require 'polyfill/v2_4/hash/instance/compact_e'
require 'polyfill/v2_4/hash/instance/transform_values'
require 'polyfill/v2_4/hash/instance/transform_values_e'

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
