module Polyfill
  module V2_4
    module Hash
      module Instance
        module CompactE
          module Method
            def compact!
              reject! { |_, v| v.nil? }
            end
          end

          refine ::Hash do
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
