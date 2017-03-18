module Polyfill
  module V2_4
    module Float
      module Instance
        module Ceil
          module Method
            def ceil(ndigits = 0)
              ndigits = ndigits.to_int
              return super() if ndigits == 0

              if ndigits > 0
                place = 10 ** ndigits
                (self * place).ceil / place.to_f
              else
                place = 10 ** -ndigits
                (self.to_f / place).ceil * place
              end
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::Float do
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
end
