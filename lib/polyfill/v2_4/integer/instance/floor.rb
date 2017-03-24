module Polyfill
  module V2_4
    module Integer
      module Instance
        module Floor
          module Method
            def floor(ndigits = 0)
              ndigits = ndigits.to_int
              return super() if ndigits == 0
              return to_f if ndigits > 0

              place = 10**-ndigits
              (to_f / place).floor * place
            end
          end

          refine ::Integer do
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
