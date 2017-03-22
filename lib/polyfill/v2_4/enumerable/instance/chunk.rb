module Polyfill
  module V2_4
    module Enumerable
      module Instance
        module Chunk
          module Method
            def chunk(*)
              return enum_for(:chunk) unless block_given?

              super
            end
          end

          refine ::Array do
            include Method
          end
          refine ::Dir do
            include Method
          end
          refine ::Enumerator do
            include Method
          end
          refine ::Hash do
            include Method
          end
          refine ::IO do
            include Method
          end
          refine ::Range do
            include Method
          end
          refine ::StringIO do
            include Method
          end
          refine ::Struct do
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
