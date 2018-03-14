module Polyfill
  module V2_5
    module Enumerable
      def any?(*pattern)
        return super if pattern.empty?

        !grep(*pattern).empty?
      end
    end
  end
end
