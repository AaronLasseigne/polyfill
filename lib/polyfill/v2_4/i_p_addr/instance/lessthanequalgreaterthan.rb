require 'ipaddr'

module Polyfill
  module V2_4
    module IPAddr
      module Instance
        module Lessthanequalgreaterthan
          module Method
            def <=>(*)
              super
            rescue
              nil
            end
          end

          refine ::IPAddr do
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
