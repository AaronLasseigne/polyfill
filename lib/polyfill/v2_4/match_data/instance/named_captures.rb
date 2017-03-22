module Polyfill
  module V2_4
    module MatchData
      module Instance
        module NamedCaptures
          module Method
            def named_captures
              names.each_with_object({}) do |name, acc|
                acc[name] = self[name]
              end
            end
          end

          refine ::MatchData do
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
