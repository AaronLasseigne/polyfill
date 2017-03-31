require 'stringio'

module Polyfill
  module V2_3
    module Enumerable
      module Instance
        module GrepV
          module Method
            def grep_v(pattern)
              output = self - grep(pattern)
              output.map!(&Proc.new) if block_given?
              output
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
