module Polyfill
  module V2_4
    module Numeric
      module InfiniteQ
        module Method
          def infinite?
            nil
          end if RUBY_VERSION < '2.4.0'

          def respond_to?(method, *)
            return true if method.to_sym == :infinite?

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
