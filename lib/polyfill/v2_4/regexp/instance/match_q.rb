module Polyfill
  module V2_4
    module Regexp
      module Instance
        module MatchQ
          module Method
            def match?(string, position = 0)
              !!(string[position..-1] =~ self)
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::Regexp do
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
