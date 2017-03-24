module Polyfill
  module V2_4
    module Integer
      module Instance
        module Digits
          module Method
            def digits(base = 10)
              base = base.to_int
              raise Math::DomainError, 'out of domain' if self < 0
              raise ArgumentError, 'negative radix' if base < 0
              raise ArgumentError, "invalid radix #{base}" if base < 2

              acc = []
              remainder = self
              while remainder > 0
                remainder, value = remainder.divmod(base)
                acc.push(value)
              end
              acc
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
