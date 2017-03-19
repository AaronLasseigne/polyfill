require 'polyfill/v2_4/string_io/instance/each_line'
require 'polyfill/v2_4/string_io/instance/gets'
require 'polyfill/v2_4/string_io/instance/readline'
require 'polyfill/v2_4/string_io/instance/readlines'

module Polyfill
  module V2_4
    module StringIO
      module Instance
        include EachLine
        include Gets
        include Readline
        include Readlines
      end
    end
  end
end
