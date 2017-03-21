module Polyfill
  module V2_4
    module Enumerator
      module Lazy
        module Instance
          module ChunkWhile
            module Method
              def chunk_while
                super.lazy
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
