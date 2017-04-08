module Polyfill
  module V2_2
    module Kernel
      module Instance
        module Itself
          module Method
            def itself
              self
            end
          end

          refine ::Object do
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
