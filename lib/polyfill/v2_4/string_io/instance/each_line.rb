module Polyfill
  module V2_4
    module StringIO
      module Instance
        module EachLine
          refine ::StringIO do
            include IO::Instance::EachLine::Method
          end

          def self.included(base)
            base.include IO::Instance::EachLine::Method
          end
        end
      end
    end
  end
end
