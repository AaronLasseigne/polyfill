module Polyfill
  module V2_4
    module Array
      def concat(*others)
        return super if others.length == 1

        acc = [].concat(self)
        others.each do |other|
          acc.concat(other)
        end

        replace(acc)
      end

      def sum(init = 0)
        acc =
          begin
            init.dup
          rescue TypeError
            init
          end

        each do |elem|
          acc += block_given? ? yield(elem) : elem
        end

        acc
      end
    end
  end
end
