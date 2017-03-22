module Polyfill
  module V2_4
    module Object
      module Instance
        module Clone
          module Method
            def clone(freeze: true)
              return super() if freeze

              cloned = dup
              (singleton_class.ancestors - self.class.ancestors).drop(1).each do |ancestor|
                cloned.extend(ancestor)
              end
              cloned
            end
          end

          refine ::Object do
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
