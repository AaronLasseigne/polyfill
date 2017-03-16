module Polyfill
  module V2_4
    module Float
      module Floor
        module Method
          def floor(ndigits = 0)
            ndigits = ndigits.to_int
            return super() if ndigits == 0

            if ndigits > 0
              place = 10 ** ndigits
              (self * place).floor / place.to_f
            else
              place = 10 ** -ndigits
              (self / place).floor * place
            end
          end if RUBY_VERSION < '2.4.0'
        end

        if RUBY_VERSION < '2.4.0'
          refine ::Float do
            include Method
          end
        end
      end
    end
  end
end
