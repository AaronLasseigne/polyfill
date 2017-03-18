require 'polyfill/v2_4/io/instance/gets'
require 'polyfill/v2_4/io/instance/readline'

module Polyfill
  module V2_4
    module IO
      module Instance
        include Gets
        include Readline
      end
    end
  end
end
