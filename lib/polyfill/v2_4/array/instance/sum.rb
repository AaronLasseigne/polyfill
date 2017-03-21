module Polyfill
  module V2_4
    module Array
      module Instance
        module Sum
          if RUBY_VERSION < '2.4.0'
            refine ::Array do
              include Enumerable::Instance::Sum::Method
            end

            def self.included(base)
              base.include Enumerable::Instance::Sum::Method
            end
          end
        end
      end
    end
  end
end
