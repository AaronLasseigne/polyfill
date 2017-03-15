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

            def respond_to?(method, *)
              return true if method.to_sym == :named_captures

              super
            end

            def methods
              super + [:named_captures]
            end
          end
          refine ::MatchData.singleton_class do
            def instance_methods
              super + [:named_captures]
            end
          end
        end
      end
    end
  end
end
