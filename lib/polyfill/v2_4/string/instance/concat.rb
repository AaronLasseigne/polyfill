module Polyfill
  module V2_4
    module String
      module Instance
        module Concat
          module Method
            def concat(*others)
              return super if others.length == 1

              acc = '' << self
              others.each do |other|
                acc << other
              end

              replace(acc)
            end
          end

          refine ::String do
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
