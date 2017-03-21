require_relative 'instance/each_line'
require_relative 'instance/gets'
require_relative 'instance/lines'
require_relative 'instance/readline'
require_relative 'instance/readlines'

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
