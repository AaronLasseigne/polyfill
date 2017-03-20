module Polyfill
  module V2_4
    module Symbol
      module Instance
        module MatchQ
          if RUBY_VERSION < '2.4.0'
            refine ::Symbol do
              include String::Instance::MatchQ::Method
            end

            def self.included(base)
              base.include String::Instance::MatchQ::Method
            end
          end
        end
      end
    end
  end
end
