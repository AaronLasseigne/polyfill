module Polyfill
  module V2_4
    module Numeric
      module FiniteQ
        module Method
          def finite?
            true
          end if RUBY_VERSION < '2.4.0'
        end

        if RUBY_VERSION < '2.4.0'
          refine ::Numeric do
            include Method
          end
        end
      end
    end
  end
end
