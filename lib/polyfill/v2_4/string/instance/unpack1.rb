module Polyfill
  module V2_4
    module String
      module Instance
        module Unpack1
          module Method
            def unpack1(*args)
              unpack(*args).first
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::String do
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
end
