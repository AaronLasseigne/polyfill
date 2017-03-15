require 'polyfill/v2_4/hash/compact'
require 'polyfill/v2_4/hash/compact_e'
require 'polyfill/v2_4/hash/transform_values'
require 'polyfill/v2_4/hash/transform_values_e'

module Polyfill
  module V2_4
    module Hash
      include Compact
      include CompactE
      include TransformValues
      include TransformValuesE
    end
  end
end
