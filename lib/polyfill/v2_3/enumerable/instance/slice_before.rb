module Polyfill
  module V2_3
    module Enumerable
      module Instance
        module SliceBefore
          module Method
            def slice_before(*args)
              if !args.empty? && block_given?
                raise ArgumentError, 'wrong number of arguments (given 1, expected 0)'
              end

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
