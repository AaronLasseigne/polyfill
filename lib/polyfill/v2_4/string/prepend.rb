module Polyfill
  module V2_4
    module String
      module Prepend
        module Method
          def prepend(*others)
            return super if others.length == 1

            acc = '' << self
            others.reverse_each do |other|
              acc.prepend(other)
            end

            replace(acc)
          end if RUBY_VERSION < '2.4.0'
        end

        refine ::String do
          include Method
        end
      end
    end
  end
end
