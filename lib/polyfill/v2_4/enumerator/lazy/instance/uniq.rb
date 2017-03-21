require 'set'

module Polyfill
  module V2_4
    module Enumerator
      module Lazy
        module Instance
          module Uniq
            module Method
              def uniq
                seen = Set.new

                ::Enumerator::Lazy.new(self) do |yielder, *values|
                  result = block_given? ? yield(*values) : values

                  yielder.<<(*values) if seen.add?(result)
                end
              end
            end

            if RUBY_VERSION < '2.4.0'
              refine ::Enumerator::Lazy do
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
end
