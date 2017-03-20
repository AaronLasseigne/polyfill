module Polyfill
  module V2_4
    module Symbol
      module Instance
        module CasecmpQ
          module Method
            def casecmp?(other)
              return nil unless other.is_a?(::Symbol)

              casecmp(other) == 0
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::Symbol do
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
