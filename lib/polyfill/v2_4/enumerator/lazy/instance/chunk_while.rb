module Polyfill
  module V2_4
    module Enumerator
      module Lazy
        module Instance
          module ChunkWhile
            module Method
              using V2_3::Enumerable::Instance::ChunkWhile

              def chunk_while
                super.lazy
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
