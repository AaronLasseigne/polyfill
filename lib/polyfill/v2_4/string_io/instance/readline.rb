module Polyfill
  module V2_4
    module StringIO
      module Instance
        module Readline
          refine ::StringIO do
            include IO::Instance::Readline::Method
          end

          def self.included(base)
            base.include IO::Instance::Readline::Method
          end
        end
      end
    end
  end
end
