require 'matrix'

module Polyfill
  module V2_6
    module Matrix
      def antisymmetric?
        raise StandardError unless square?
        each_with_index(:upper) do |e, row, col|
          return false unless e == -rows[col][row]
        end
        true
      end
    end
  end
end
