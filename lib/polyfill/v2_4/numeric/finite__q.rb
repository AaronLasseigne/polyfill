module Polyfill
  module V2_4
    module Numeric
      module Finite__Q
        module Method
          def finite?
            true
          end if RUBY_VERSION < '2.4.0'

          def respond_to?(method, *)
            return true if method.to_sym == :finite?

            super
          end if RUBY_VERSION < '2.4.0'
        end

        refine ::Numeric do
          include Method
        end
      end
    end
  end
end
