module Polyfill
  module V2_4
    module Hash
      module CompactE
        module Method
          def compact!
            reject! { |_, v| v.nil? }
          end if RUBY_VERSION < '2.4.0'
        end

        refine ::Hash do
          include Method
        end
      end
    end
  end
end
