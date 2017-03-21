module Polyfill
  module V2_4
    module Enumerable
      module Instance
        module Sum
          module Method
            def sum(init = 0)
              acc =
                begin
                  init.dup
                rescue TypeError
                  init
                end

              each do |elem|
                acc += block_given? ? yield(elem) : elem
              end

              acc
            end
          end

          if RUBY_VERSION < '2.4.0'
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
end
