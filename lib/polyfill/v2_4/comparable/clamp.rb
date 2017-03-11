module Polyfill
  module V2_4
    module Comparable
      module Clamp
        module Method
          def clamp(min, max)
            if min > max
              raise ArgumentError, 'min argument must be smaller than max argument'
            end

            return min if min > self
            return max if max < self
            self
          end

          def respond_to?(method, *)
            return true if method.to_sym == :clamp

            super
          end
        end

        refine ::Numeric do
          include Method
        end
        refine ::String do
          include Method
        end
        refine ::Time do
          include Method
        end
      end
    end
  end
end
