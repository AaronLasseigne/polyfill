module Polyfill
  module V2_3
    module String
      module Instance
        module PlusUnary
          module Method
            def +@
              frozen? ? dup : self
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
