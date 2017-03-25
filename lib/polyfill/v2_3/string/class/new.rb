module Polyfill
  module V2_3
    module String
      module Class
        module New
          module Method
            def new(*args)
              hash, others = args.partition { |arg| arg.is_a?(::Hash) }
              hash = hash.first
              encoding = hash && hash.delete(:encoding)

              if hash && !hash.keys.empty?
                raise ArgumentError, "unknown keyword: #{hash.keys.first}"
              end

              str = super(*others)
              str.encode!(encoding) if encoding
              str
            end
          end

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
