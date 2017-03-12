module Polyfill
  module V2_4
    module Array
      module Concat
        module Method
          def concat(*others)
            return super if others.length == 1

            acc = [].concat(self)
            others.each do |other|
              acc.concat(other)
            end

            replace(acc)
          end if RUBY_VERSION < '2.4.0'
        end

        refine ::Array do
          include Method
        end
      end
    end
  end
end
