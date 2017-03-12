module Polyfill
  module V2_4
    module Integer
      module Digits
        refine ::Integer do
          def digits(base = 10)
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
          end if RUBY_VERSION < '2.4.0'

          def respond_to?(method, *)
            return true if method.to_sym == :digits

            super
          end if RUBY_VERSION < '2.4.0'
        end
      end
    end
  end
end
