module Polyfill
  module V2_4
    module String
      module Concat
        module Method
          def concat(*others)
            return super if others.length == 1

            acc = '' << self
            others.each do |other|
              acc << other
            end

            replace(acc)
          end if RUBY_VERSION < '2.4.0'
        end

        refine ::String do
          include Method
        end
      end
    end
  end
end
