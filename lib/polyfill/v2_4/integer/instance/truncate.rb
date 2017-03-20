module Polyfill
  module V2_4
    module Integer
      module Instance
        module Truncate
          module Method
            def truncate(ndigits = 0)
              ndigits = ndigits.to_int
              return super() if ndigits == 0
              return to_f if ndigits > 0

              place = 10**-ndigits
              (to_f / place).truncate * place
            end
          end

          if RUBY_VERSION < '2.4.0'
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
end
