module Polyfill
  module V2_4
    module String
      module Class
        module New
          module Method
            def new(*args)
              hash = args.find { |arg| arg.is_a?(::Hash) }
              hash.delete(:capacity) if hash

              super(*args)
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::String.singleton_class do
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
