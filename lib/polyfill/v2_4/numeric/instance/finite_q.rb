module Polyfill
  module V2_4
    module Numeric
      module Instance
        module FiniteQ
          module Method
            def finite?
              true
            end
          end

          refine ::Numeric do
            include Method
          end

          def self.included(base)
            base.include Method
          end
        end
      end
    end
  end
end
