module Polyfill
  module V2_4
    module Array
      module Instance
        module Sum
          refine ::Array do
            include Enumerable::Instance::Sum::Method
          end

          def self.included(base)
            base.include Enumerable::Instance::Sum::Method
          end
        end
      end
    end
  end
end
