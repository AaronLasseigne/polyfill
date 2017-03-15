require 'polyfill/v2_4/hash/compact'
require 'polyfill/v2_4/hash/compact__e'
require 'polyfill/v2_4/hash/transform_values'

module Polyfill
  module V2_4
    module Hash
      include Compact
      include Compact__E
      include Transform_values
    end
  end
end
