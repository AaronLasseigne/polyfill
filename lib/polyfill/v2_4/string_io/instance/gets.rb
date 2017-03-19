module Polyfill
  module V2_4
    module StringIO
      module Instance
        module Gets
          if RUBY_VERSION < '2.4.0'
            refine ::StringIO do
              include IO::Instance::Gets::Method
            end

            def self.included(base)
              base.include IO::Instance::Gets::Method
            end
          end
        end
      end
    end
  end
end
