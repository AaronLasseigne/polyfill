module Polyfill
  module V2_4
    module Numeric
      module Instance
        module Dup
          module Method
            def dup
              self
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
