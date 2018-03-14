module Polyfill
  module V2_5
    module Enumerable
      def all?(*pattern)
        return super if pattern.empty?

        grep(*pattern).size == size
      end

      def any?(*pattern)
        return super if pattern.empty?

        !grep(*pattern).empty?
      end
    end
  end
end
