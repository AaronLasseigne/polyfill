module Polyfill
  module V2_3
    module String
      module Instance
        module MinusUnary
          module Method
            def -@
              frozen? ? self : dup.freeze
            end
          end

          refine ::String do
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
