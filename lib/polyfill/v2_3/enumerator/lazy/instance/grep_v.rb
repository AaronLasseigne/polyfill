module Polyfill
  module V2_3
    module Enumerator
      module Lazy
        module Instance
          module GrepV
            module Method
              using V2_3::Enumerable::Instance::GrepV

              def grep_v(pattern)
                ::Enumerator::Lazy.new(self) do |yielder, element|
                  next if pattern === element # rubocop:disable Style/CaseEquality

                  yielder << (block_given? ? yield(element) : element)
                end
              end
            end

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
