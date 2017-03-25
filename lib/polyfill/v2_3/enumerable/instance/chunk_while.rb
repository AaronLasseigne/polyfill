require 'stringio'

module Polyfill
  module V2_3
    module Enumerable
      module Instance
        module ChunkWhile
          module Method
            def chunk_while
              block = Proc.new

              return [self] if size == 1

              Enumerator.new do |yielder|
                output = []
                each_cons(2).with_index(1) do |(a, b), run|
                  if run == size - 1
                    if block.call(a, b)
                      output.push(a, b)
                      yielder << output
                    else
                      output.push(a)
                      yielder << output
                      yielder << [b]
                    end
                  else
                    output.push(a)
                    unless block.call(a, b)
                      yielder << output
                      output = []
                    end
                  end
                end
              end
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
