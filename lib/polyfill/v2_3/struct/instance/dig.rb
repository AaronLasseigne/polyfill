module Polyfill
  module V2_3
    module Struct
      module Instance
        module Dig
          refine ::Struct do
            include Array::Instance::Dig::Method
          end

          def self.included(base)
            base.include Array::Instance::Dig::Method
          end
        end
      end
    end
  end
end
