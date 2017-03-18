module Polyfill
  module V2_4
    module File
      module EmptyQ
        module Method
          def empty?(file_name)
            zero?(file_name)
          end if RUBY_VERSION < '2.4.0'
        end

        if RUBY_VERSION < '2.4.0'
          refine ::File.singleton_class do
            include Method
          end
        end
      end
    end
  end
end
