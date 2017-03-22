module Polyfill
  module V2_4
    module String
      module Instance
        module Unpack1
          module Method
            def unpack1(*args)
              unpack(*args).first
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
