module Polyfill
  module V2_4
    module String
      module Instance
        module MatchQ
          module Method
            def match?(pattern, position = 0)
              !!(self[position..-1] =~ pattern)
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
