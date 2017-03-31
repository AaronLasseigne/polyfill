require_relative 'string/class'
require_relative 'string/instance'

module Polyfill
  module V2_3
    module String
      include Class
      include Instance
    end
  end
end
