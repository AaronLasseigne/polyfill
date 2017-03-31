module Polyfill
  module V2_3
    module Hash
      module Instance
        module Dig
          refine ::Hash do
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
