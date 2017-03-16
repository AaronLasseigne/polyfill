module Polyfill
  module V2_4
    module MatchData
      module NamedCaptures
        module Method
          def named_captures
            names.each_with_object({}) do |name, acc|
              acc[name] = self[name]
            end
          end if RUBY_VERSION < '2.4.0'
        end

        if RUBY_VERSION < '2.4.0'
          refine ::MatchData do
            include Method
          end
        end
      end
    end
  end
end
