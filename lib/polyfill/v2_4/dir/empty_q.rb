module Polyfill
  module V2_4
    module Dir
      module EmptyQ
        module Method
          def empty?(path_name)
            exist?(path_name) && (entries(path_name) - ['.', '..']).empty?
          end if RUBY_VERSION < '2.4.0'
        end

        if RUBY_VERSION < '2.4.0'
          refine ::Dir.singleton_class do
            include Method
          end
        end
      end
    end
  end
end
