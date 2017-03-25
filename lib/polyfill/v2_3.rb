require_relative 'v2_3/enumerable'
require_relative 'v2_3/string'

module Polyfill
  module V2_3
    include Enumerable
    include String
  end
end
