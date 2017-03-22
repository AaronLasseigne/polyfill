module Polyfill
  module V2_4
    module Dir
      module Class
        module EmptyQ
          module Method
            def empty?(path_name)
              exist?(path_name) && (entries(path_name) - ['.', '..']).empty?
            end
          end

          refine ::Dir.singleton_class do
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
