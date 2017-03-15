module Polyfill
  module V2_4
    module Hash
      module TransformValuesE
        module Method
          if RUBY_VERSION < '2.4.0'
            def transform_values!
              unless block_given?
                return Enumerator.new(keys.size) do |yielder|
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
        end

        if RUBY_VERSION < '2.4.0'
          refine ::Hash do
            include Method

            def respond_to?(method, *)
              return true if method.to_sym == :transform_values!

              super
            end

            def methods
              super + [:transform_values!]
            end
          end
          refine ::Hash.singleton_class do
            def instance_methods
              super + [:transform_values!]
            end
          end
        end
      end
    end
  end
end
