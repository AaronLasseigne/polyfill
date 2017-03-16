module Polyfill
  module V2_4
    module MatchData
      module ValuesAt
        module Method
          def values_at(*indexes)
            indexes.each_with_object([]) do |index, acc|
              acc.push(self[index])
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
