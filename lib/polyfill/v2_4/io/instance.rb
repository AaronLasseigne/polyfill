require 'polyfill/v2_4/io/instance/each_line'
require 'polyfill/v2_4/io/instance/gets'
require 'polyfill/v2_4/io/instance/lines'
require 'polyfill/v2_4/io/instance/readline'
require 'polyfill/v2_4/io/instance/readlines'

module Polyfill
  module V2_4
    module IO
      module Instance
        include EachLine
        include Gets
        include Lines
        include Readline
        include Readlines
      end
    end
  end
end
