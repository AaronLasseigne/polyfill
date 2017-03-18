module Polyfill
  module V2_4
    module Hash
      module Instance
        module Compact
          module Method
            def compact
              reject { |_, v| v.nil? }
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::Hash do
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
