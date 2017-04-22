require_relative 'v2_2/enumerable'
require_relative 'v2_2/kernel'

module Polyfill
  module V2_2
    include Enumerable
    include Kernel
  end
end
