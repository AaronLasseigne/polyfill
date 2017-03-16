module Polyfill
  module V2_4
    module Hash
      module TransformValues
        module Method
          if RUBY_VERSION < '2.4.0'
            def transform_values
              unless block_given?
                return Enumerator.new(keys.size) do |yielder|
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
        end

        if RUBY_VERSION < '2.4.0'
          refine ::Hash do
            include Method
          end
        end
      end
    end
  end
end
