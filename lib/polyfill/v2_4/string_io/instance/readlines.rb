module Polyfill
  module V2_4
    module StringIO
      module Instance
        module Readlines
          if RUBY_VERSION < '2.4.0'
            refine ::StringIO do
              include IO::Instance::Readlines::Method
            end

            def self.included(base)
              base.include IO::Instance::Readlines::Method
            end
          end
        end
      end
    end
  end
end
