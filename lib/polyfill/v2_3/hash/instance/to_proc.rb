module Polyfill
  module V2_3
    module Hash
      module Instance
        module ToProc
          module Method
            def to_proc
              method(:[]).to_proc
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
