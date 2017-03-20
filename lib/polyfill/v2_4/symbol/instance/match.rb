module Polyfill
  module V2_4
    module Symbol
      module Instance
        module Match
          module Method
            def match(*args)
              if block_given?
                to_s.match(*args, &Proc.new)
              else
                to_s.match(*args)
              end
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::Symbol do
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
