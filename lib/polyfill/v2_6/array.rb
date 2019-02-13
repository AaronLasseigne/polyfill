module Polyfill
  module V2_6
    module Array
      def difference(*arrays)
        arrays.reduce([*self]) do |me, array|
          me - array
        end
      end

      def union(*arrays)
        return self | [] if arrays.empty?

        arrays.reduce(self) do |me, array|
          me | array
        end
      end
    end
  end
end
