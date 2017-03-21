require_relative 'io/class'
require_relative 'io/instance'

module Polyfill
  module V2_4
    module IO
      include Class
      include Instance
    end
  end
end
