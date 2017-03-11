require 'polyfill/v2_4/array'
require 'polyfill/v2_4/comparable'
require 'polyfill/v2_4/integer'

module Polyfill
  module V2_4
    include Array
    include Comparable
    include Integer
  end
end
