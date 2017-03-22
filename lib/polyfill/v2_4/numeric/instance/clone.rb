module Polyfill
  module V2_4
    module Numeric
      module Instance
        module Clone
          module Method
            def clone(freeze: true) # rubocop:disable Lint/UnusedMethodArgument
              self
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::Numeric do
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
end
