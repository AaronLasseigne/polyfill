module Polyfill
  module V2_4
    module String
      module Instance
        module CasecmpQ
          module Method
            def casecmp?(other)
              casecmp(other.to_str) == 0
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
