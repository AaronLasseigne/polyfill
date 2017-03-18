require 'polyfill/v2_4/io/gets'
require 'polyfill/v2_4/io/readline'

module Polyfill
  module V2_4
    module IO
      include Gets
      include Readline
    end
  end
end
