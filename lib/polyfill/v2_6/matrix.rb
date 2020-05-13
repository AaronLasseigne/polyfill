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

      def collect(which = :all)
        return to_enum(:collect, which) unless block_given?
        dup.each_with_index(which) { |e, row_index, col_index| @rows[row_index][col_index] = yield e }
      end

      def collect!(which = :all)
        return to_enum(:collect!, which) unless block_given?
        raise FrozenError, "can't modify frozen Matrix" if frozen?
        each_with_index(which) { |e, row_index, col_index| @rows[row_index][col_index] = yield e }
      end

      # Alias of #antisymmetric?
      def skew_symmetric?
        raise StandardError unless square?
        each_with_index(:upper) do |e, row, col|
          return false unless e == -rows[col][row]
        end
        true
      end
    end
  end
end
