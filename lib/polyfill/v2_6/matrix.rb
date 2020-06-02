require 'matrix'

module Polyfill
  module V2_6
    module Matrix # rubocop:disable Metrics/ModuleLength
      def []=(i, j, v)
        raise FrozenError, "can't modify frozen Matrix" if frozen?
        check_range = lambda do |val, direction|
          return unless val.is_a?(Range)
          count = direction == :row ? row_count : column_count
          canonical = (val.begin + (val.begin < 0 ? count : 0))..
                  (val.end ? val.end + (val.end < 0 ? count : 0) - (val.exclude_end? ? 1 : 0) # rubocop:disable Style/NestedTernaryOperator, Style/MultilineTernaryOperator
                           : count - 1)
          unless 0 <= canonical.begin && canonical.begin <= canonical.end && canonical.end < count
            raise IndexError, "given range #{val} is outside of #{direction} dimensions: 0...#{count}"
          end
          canonical
        end
        check_int = lambda do |val, direction|
          count = direction == :row ? row_count : column_count
          val = CoercionHelper.coerce_to_int(val)
          if val >= count || val < -count
            raise IndexError, "given #{direction} #{val} is outside of #{-count}...#{count}"
          end
          val
        end
        set_row_and_col_range = lambda do |row_range, col_range, value|
          if value.is_a?(Matrix)
            if row_range.size != value.row_count || col_range.size != value.column_count
              raise StandardError, [
                'Expected a Matrix of dimensions',
                "#{row_range.size}x#{col_range.size}",
                'got',
                "#{value.row_count}x#{value.column_count}"
              ].join(' ')
            end
            source = value.instance_variable_get :@rows
            row_range.each_with_index do |row, source_row|
              @rows[row][col_range] = source[source_row]
            end
          elsif value.is_a?(Vector)
            raise StandardError, 'Expected a Matrix or a value, got a Vector'
          else
            value_to_set = Array.new(col_range.size, value)
            row_range.each do |r|
              @rows[r][col_range] = value_to_set
            end
          end
        end
        set_column_vector = lambda do |row_range, col, value|
          value.each_with_index do |e, index|
            r = row_range.begin + index
            @rows[r][col] = e
          end
        end
        set_row_range = lambda do |row_range, col, value|
          if value.is_a?(Vector)
            raise StandardError unless row_range.size == value.size
            set_column_vector.call(row_range, col, value)
          elsif value.is_a?(Matrix)
            raise StandardError unless value.column_count == 1
            value = value.column(0)
            raise StandardError unless row_range.size == value.size
            set_column_vector.call(row_range, col, value)
          else
            @rows[row_range].each { |e| e[col] = value }
          end
        end
        set_col_range = lambda do |row, col_range, value|
          value = if value.is_a?(Vector)
                    value.to_a
                  elsif value.is_a?(Matrix)
                    raise StandardError unless value.row_count == 1
                    value.row(0).to_a
                  else
                    Array.new(col_range.size, value)
                  end
          raise StandardError unless col_range.size == value.size
          @rows[row][col_range] = value
        end
        set_value = lambda do |row, col, value|
          raise StandardError, "Expected a a value, got a #{value.class}" if value.respond_to?(:to_matrix)

          @rows[row][col] = value
        end
        (rows = check_range.call(i, :row)) || (row = check_int.call(i, :row))
        (columns = check_range.call(j, :column)) || (column = check_int.call(j, :column))
        if rows && columns
          set_row_and_col_range.call(rows, columns, v)
        elsif rows
          set_row_range.call(rows, column, v)
        elsif columns
          set_col_range.call(row, columns, v)
        else
          set_value.call(row, column, v)
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
