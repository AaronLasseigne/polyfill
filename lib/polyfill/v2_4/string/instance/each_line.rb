module Polyfill
  module V2_4
    module String
      module Instance
        module EachLine
          if RUBY_VERSION < '2.4.0'
            refine ::String do
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
end
