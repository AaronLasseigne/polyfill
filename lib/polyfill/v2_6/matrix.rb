require 'matrix'

module Polyfill
  module V2_6
    module Matrix
      def []=(i, j, v)
        raise FrozenError, "can't modify frozen Matrix" if frozen?
        (rows = check_range(i, :row)) || (row = check_int(i, :row))
        (columns = check_range(j, :column)) || (column = check_int(j, :column))
        if rows && columns
          set_row_and_col_range(rows, columns, v)
        elsif rows
          set_row_range(rows, column, v)
        elsif columns
          set_col_range(row, columns, v)
        else
          set_value(row, column, v)
        end
      end

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

      # Alias of #collect
      def map(which = :all)
        return to_enum(:collect, which) unless block_given?
        dup.each_with_index(which) { |e, row_index, col_index| @rows[row_index][col_index] = yield e }
      end

      # Alias of #collect!
      def map!(which = :all)
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
