require 'English'

module Polyfill
  module V2_4
    module IO
      module Class
        module Readlines
          module Method
            def readlines(file_name, *args)
              hash, others = args.partition { |arg| arg.is_a?(::Hash) }

              inputs = super(file_name, *others)

              if hash[0] && hash[0][:chomp]
                separator = others.find do |other|
                  other.respond_to?(:to_str)
                end || $INPUT_RECORD_SEPARATOR

                inputs.each { |input| input.chomp!(separator) }
              end

              inputs
            end
          end

          refine ::IO.singleton_class do
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
