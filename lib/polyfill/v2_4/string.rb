require_relative 'string/class'
require_relative 'string/instance'

module Polyfill
  module V2_4
    module String
      include Class
      include Instance
    end
  end
end
