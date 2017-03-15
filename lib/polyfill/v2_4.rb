require 'polyfill/v2_4/array'
require 'polyfill/v2_4/comparable'
require 'polyfill/v2_4/float'
require 'polyfill/v2_4/hash'
require 'polyfill/v2_4/integer'
require 'polyfill/v2_4/match_data'
require 'polyfill/v2_4/numeric'
require 'polyfill/v2_4/string'

module Polyfill
  module V2_4
    include Array
    include Comparable
    include Float
    include Hash
    include Integer
    include MatchData
    include Numeric
    include String
  end
end
