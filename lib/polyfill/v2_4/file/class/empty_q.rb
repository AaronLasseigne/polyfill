module Polyfill
  module V2_4
    module File
      module Class
        module EmptyQ
          module Method
            def empty?(file_name)
              zero?(file_name)
            end
          end

          refine ::File.singleton_class do
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
