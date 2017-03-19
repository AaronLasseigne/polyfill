module Polyfill
  module V2_4
    module IO
      module Instance
        module Readlines
          module Method
            def readlines(*args)
              hash, others = args.partition { |arg| arg.is_a?(::Hash) }

              inputs = super(*others)

              if hash[0] && hash[0][:chomp]
                separator = others.find { |other| other.respond_to?(:to_str) }
                if separator
                  inputs.each { |input| input.chomp!(separator) }
                else
                  inputs.each(&:chomp!)
                end
              end

              inputs
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::IO do
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
