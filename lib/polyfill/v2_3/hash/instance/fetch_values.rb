module Polyfill
  module V2_3
    module Hash
      module Instance
        module FetchValues
          module Method
            def fetch_values(*keys)
              keys.each_with_object([]) do |key, values|
                value =
                  if block_given?
                    fetch(key, &Proc.new)
                  else
                    fetch(key)
                  end

                values << value
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
