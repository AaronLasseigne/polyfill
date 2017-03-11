module Polyfill
  module V2_4
    module Array
      module Concat
        refine ::Array do
          def concat(*others)
            return super if others.length == 1

            acc = [].concat(self)
            others.each do |other|
              acc.concat(other)
            end

            replace(acc)
          end
        end
      end
    end
  end
end
