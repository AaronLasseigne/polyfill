module Polyfill
  module V2_4
    module Hash
      module Instance
        module TransformValuesE
          module Method
            def transform_values!
              unless block_given?
                return ::Enumerator.new(keys.size) do |yielder|
                  replace(each_with_object({}) do |(k, v), acc|
                    acc[k] = yielder.yield(v)
                  end)
                end
              end

              replace(each_with_object({}) do |(k, v), acc|
                acc[k] = yield(v)
              end)
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
