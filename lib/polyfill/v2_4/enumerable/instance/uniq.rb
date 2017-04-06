module Polyfill
  module V2_4
    module Enumerable
      module Instance
        module Uniq
          module Method
            def uniq
              if block_given?
                to_a.uniq(&::Proc.new)
              else
                to_a.uniq
              end
            end
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
