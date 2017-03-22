module Polyfill
  module V2_4
    module Hash
      module Instance
        module TransformValues
          module Method
            def transform_values
              unless block_given?
                return ::Enumerator.new(keys.size) do |yielder|
                  each_with_object({}) do |(k, v), acc|
                    acc[k] = yielder.yield(v)
                  end
                end
              end

              each_with_object({}) do |(k, v), acc|
                acc[k] = yield(v)
              end
            end
          end

          refine ::Hash do
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
