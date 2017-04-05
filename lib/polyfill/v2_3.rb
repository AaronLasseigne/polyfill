require_relative 'v2_3/array'
require_relative 'v2_3/hash'
require_relative 'v2_3/enumerable'
require_relative 'v2_3/enumerator/lazy'
require_relative 'v2_3/string'
require_relative 'v2_3/struct'

module Polyfill
  module V2_3
    include Array
    include Hash
    include Enumerable
    include Enumerator::Lazy
    include String
    include Struct
  end
end
